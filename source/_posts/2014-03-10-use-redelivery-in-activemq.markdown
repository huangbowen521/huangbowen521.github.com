---
layout: post
title: ActiveMQ第五弹:增加ReDelivery功能
date: 2014-03-10 01:17
comments: true
categories: ActiveMQ
---

在使用Message Queue的过程中，总会由于种种原因而导致消息失败。一个经典的场景是一个生成者向Queue中发消息，里面包含了一组邮件地址和邮件内容。而消费者从Queue中将消息一条条读出来，向指定邮件地址发送邮件。消费者在发送消息的过程中由于种种原因会导致失败，比如网络超时、当前邮件服务器不可用等。这样我们就希望建立一种机制，对于未发送成功的邮件再重新发送，也就是重新处理。重新处理超过一定次数还不成功，就放弃对该消息的处理，记录下来，继续对剩余消息进行处理。

<!-- more -->

ActiveMQ为我们实现了这一功能，叫做ReDelivery(重新投递)。当消费者在处理消息时有异常发生，会将消息重新放回Queue里，进行下一次处理。当超过重试次数时，消息会被放置到一个特殊的Queue中，即Dead Letter Queue,简称DLQ，用于进行后续分析。

废话不多说，一起来实现吧。（该示例中的全部代码已放置到[GitHub](https://github.com/huangbowen521/SpringJMSSample)上，请自行下载。）

还是接着本系列中的示例代码来进行。要实现ReDelivery功能，要给LinsterContainer加上事务处理。设置SimpleMessageListenerContainer的sessionTransacted属性为true。

```xml activeMQConnection.xml

    <!-- Message Receiver Definition -->
    <bean id="messageReceiver" class="huangbowen.net.jms.retry.MessageReceiver">
    </bean>
    <bean class="org.springframework.jms.listener.SimpleMessageListenerContainer">
        <property name="connectionFactory" ref="connectionFactory"/>
        <property name="destinationName" value="${jms.queue.name}"/>
        <property name="messageListener" ref="messageReceiver"/>
        <property name="sessionTransacted" value="true" />
    </bean>

```

然后创建一个ReDeliveryPolicy，来定义ReDelivery的机制。

```xml activeMQConnection.xml

    <amq:redeliveryPolicy id="activeMQRedeliveryPolicy" destination="#defaultDestination" redeliveryDelay="100" maximumRedeliveries="4" />

```

这里设置ReDelivery的时间间隔是100毫秒，最大重发次数是4次。

在ActiveMQ的Connection Factory中应用这个Policy。就是给Connection Factory设置属性redeliveryPolicy为我们刚刚创建的Policy。

```xml activeMQConnection.xml

    <!-- Activemq connection factory -->
    <bean id="amqConnectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
        <property name="brokerURL" value="${jms.broker.url}?"/>
        <property name="useAsyncSend" value="true"/>
        <property name="redeliveryPolicy" ref="activeMQRedeliveryPolicy" />
    </bean>

```

这样ReDelivery机制就设置好了。那么怎么能证明我不是在忽悠你们那？当然最好的办法是写自动化测试来测试这个功能了。

首先修改下broker的配置，将其对消息的持久化设置为false，这样每次运行测试时Queue中消息都为0，用于还原现场。然后设置一个Destination Policy，当消息超过重试次数仍未被正确处理时，就把它放入到以`DLQ.`为前缀的Queue中。由于ActiveMQ默认对非持久化的Message不放入DLQ中的，所以手动设置processNonPersistent为true。

```xml activeMQConnection.xml

    <amq:broker id="activeMQBroker" persistent="false">
        <amq:transportConnectors>
            <amq:transportConnector uri="${jms.broker.url}"/>
        </amq:transportConnectors>
        <amq:destinationPolicy>
            <amq:policyMap>
                <amq:policyEntries>
                    <amq:policyEntry queue=">">
                        <amq:deadLetterStrategy>
                            <amq:individualDeadLetterStrategy
                                    queuePrefix="DLQ." useQueueForQueueMessages="true" processExpired="true"
                                    processNonPersistent="true" />
                        </amq:deadLetterStrategy>
                    </amq:policyEntry>
                </amq:policyEntries>
            </amq:policyMap>
        </amq:destinationPolicy>
    </amq:broker>

```

然后新建一个MessageListener，当接收到消息就抛出一个异常，这样用以启动ReDelivery机制。

```java retry/MessageReceiver

package huangbowen.net.jms.retry;

import org.springframework.jms.support.JmsUtils;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

public class MessageReceiver implements MessageListener {

    public void onMessage(Message message) {
        if(message instanceof TextMessage) {
            TextMessage textMessage = (TextMessage) message;
            try {
                String text = textMessage.getText();
                System.out.println(String.format("Received: %s",text));
                throw new JMSException("process failed");
            } catch (JMSException e) {
                System.out.println("there is JMS exception: " + e.getMessage() );
                throw JmsUtils.convertJmsAccessException(e);
            }
        }
    }
}

```

最后新建一个集成测试类。

```java ReDeliveryFunctionIntegrationTest.java

package huangbowen.net;

import huangbowen.net.jms.MessageSender;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.BrowserCallback;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

import javax.jms.JMSException;
import javax.jms.QueueBrowser;
import javax.jms.Session;
import java.util.Enumeration;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;

@ContextConfiguration(locations = {"/retry/activeMQConnection.xml"})
@DirtiesContext
public class ReDeliveryFunctionIntegrationTest extends AbstractJUnit4SpringContextTests {


    private final static String DLQ = "DLQ.bar";
    @Autowired
    public JmsTemplate jmsTemplate;

    @Autowired
    public MessageSender messageSender;


    private int getMessagesInDLQ() {
        return jmsTemplate.browse(DLQ, new BrowserCallback<Integer>() {
            @Override
            public Integer doInJms(Session session, QueueBrowser browser) throws JMSException {
                Enumeration messages = browser.getEnumeration();
                int total = 0;
                while(messages.hasMoreElements()) {
                    messages.nextElement();
                    total++;
                }

                return  total;
            }
        });
    }

    @Test
    public void shouldRetryIfExceptionHappened() throws Exception {

        assertThat(getMessagesInDLQ(), is(0));

        messageSender.send("this is a message");
        Thread.sleep(5000);

        assertThat(getMessagesInDLQ(), is(1));
    }
} 


```

我们通过Spring的Autowired功能拿到配置中的JmsTemplate和MessageSender。使用JmsTemplate的brower方法来读取当前DLQ.bar Queue中有多少剩余的消息。用MessageSender来发送一条消息，这样即使我们有Listener来处理这条消息，但是由于每次都会抛出异常，超过限定次数后，被放置到了DLQ.bar中。我们检测DLQ.bar中的消息数量就可以知道ReDelivery功能是否正确。

运行测试，成功通过。这是日志信息：

```text

send: this is a message
Received: this is a message
there is JMS exception: process failed
Received: this is a message
there is JMS exception: process failed
Received: this is a message
there is JMS exception: process failed
Received: this is a message
there is JMS exception: process failed
Received: this is a message
there is JMS exception: process failed

Process finished with exit code 0

```

本系列的全部示例代码请在[https://github.com/huangbowen521/SpringJMSSample](https://github.com/huangbowen521/SpringJMSSample)下载。


