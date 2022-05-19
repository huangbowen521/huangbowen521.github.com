---
layout: post
title: AWS开发人员认证考试样题解析
date: 2016-07-27 11:40:02 +0800
comments: true
categories: AWS
---

最近在准备AWS的开发人员考试认证。所以特意做了一下考试样题。每道题尽量给出了文档出处以及解析。

<!-- more -->

-----------

Which of the following statements about SQS is true?

A. Messages will be delivered exactly once and messages will be delivered in First in, First out order

B. Messages will be delivered exactly once and message delivery order is indeterminate

C. Messages will be delivered one or more times and messages will be delivered in First in, First out order

D. Messages will be delivered one or more times and message delivery order is indeterminate

答案：D

参考文档：https://aws.amazon.com/sqs/faqs/

解析：SQS为了保持高可用，会在多个服务器间duplicate消息，所以消息可能会被delivery多次，但会保证至少被delivery一次；另外由于分布式的特性，所以消息的delivery顺序无法得到保证


-------------

EC2 instances are launched from Amazon Machine Images (AMIs). A given public AMI:

A. can be used to launch EC2 instances in any AWS region

B. can only be used to launch EC2 instances in the same country as the AMI is stored

C. can only be used to launch EC2 instances in the same AWS region as the AMI is stored

D. can only be used to launch EC2 instances in the same AWS availability zone as the AMI is stored

答案：C

参考文档：http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html

解析：AMI只在当前region可用（不过AMI的ID是global范围内唯一的）；如果想跨region的话需要copy到其它region。

------------

Company B provides an online image recognition service and utilizes SQS to decouple system
components for scalability. The SQS consumers poll the imaging queue as often as possible to keep endto-end
throughput as high as possible. However, Company B is realizing that polling in tight loops is
burning CPU cycles and increasing costs with empty responses. How can Company B reduce the number
of empty responses?

A. Set the imaging queue VisibilityTimeout attribute to 20 seconds

B. Set the imaging queue ReceiveMessageWaitTimeSeconds attribute to 20 seconds

C. Set the imaging queue MessageRetentionPeriod attribute to 20 seconds

D. Set the DelaySeconds parameter of a message to 20 seconds

答案：B

参考文档：http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-long-polling.html

解析：这个需要使用SQS的long pulling；方式之一就是设置queue的ReceiveMessageWaitTimeSeconds属性

-------------

You attempt to store an object in the US-STANDARD region in Amazon S3, and receive a confirmation
that it has been successfully stored. You then immediately make another API call and attempt to read
this object. S3 tells you that the object does not exist. What could explain this behavior?

A. US-STANDARD uses eventual consistency and it can take time for an object to be readable in a bucket.

B. Objects in Amazon S3 do not become visible until they are replicated to a second region.

C. US-STANDARD imposes a 1 second delay before new objects are readable

D. You exceeded the bucket object limit, and once this limit is raised the object will be visible.

答案：A

参考文档：http://docs.aws.amazon.com/AmazonS3/latest/dev/Introduction.html

解析：这道题有点过时了，当时US-STANDARD不支持read-after-write，使用的是eventual consistency，所以当写入一个object以后，不一定会立即读到。现在已经没有US-STANDARD region了（被重命名了）。而且所有region都支持read-after-write了。

--------------

You have reached your account limit for the number of CloudFormation stacks in a region. How do you
increase your limit?

A. Make an API call

B. Contact AWS

C. Use the console

D. You cannot increase your limit

答案：B

参考文档： http://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html#limits_cloudformation

http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html

解析：stack数量的限制只是一个软限制，所以可以通过向AWS发请求来放宽限制。

--------------

Which statements about DynamoDB are true? (Pick 2 correct answers)

A. DynamoDB uses a pessimistic locking model

B. DynamoDB uses optimistic concurrency control

C. DynamoDB uses conditional writes for consistency

D. DynamoDB restricts item access during reads

E. DynamoDB restricts item access during writes

答案：BC

参考文档： http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html
解析：这个题目需要对DynamoDB有深入了解，具体可以查看相关文档

-----------------

What is one key difference between an Amazon EBS-backed and an instance-store backed instance?

A. Instance-store backed instances can be stopped and restarted

B. Auto scaling requires using Amazon EBS-backed instances

C. Amazon EBS-backed instances can be stopped and restarted

D. Virtual Private Cloud requires EBS backed instances

答案：C

参考文档：http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html

----------------------

A corporate web application is deployed within an Amazon VPC, and is connected to the corporate data
center via IPSec VPN. The application must authenticate against the on-premise LDAP server. Once
authenticated, logged-in users can only access an S3 keyspace specific to the user.
Which two approaches can satisfy the objectives?

A. The application authenticates against LDAP. The application then calls the IAM Security Service to login
to IAM using the LDAP credentials. The application can use the IAM temporary credentials to access the
appropriate S3 bucket.

B. The application authenticates against LDAP, and retrieves the name of an IAM role associated with the
user. The application then calls the IAM Security Token Service to assume that IAM Role. The application
can use the temporary credentials to access the appropriate S3 bucket.

C. The application authenticates against IAM Security Token Service using the LDAP credentials. The
application uses those temporary AWS security credentials to access the appropriate S3 bucket.

D. Develop an identity broker which authenticates against LDAP, and then calls IAM Security Token Service
to get IAM federated user credentials. The application calls the identity broker to get IAM federated user
credentials with access to the appropriate S3 bucket.

E. Develop an identity broker which authenticates against IAM Security Token Service to assume an IAM
Role to get temporary AWS security credentials. The application calls the identity broker to get AWS
temporary security credentials with access to the appropriate S3 bucket.

答案：BD

参考文档：https://aws.amazon.com/blogs/aws/aws-identity-and-access-management-now-with-identity-federation/

解析：IAM认证一向是考察的重点。B采用的是assume role的方式，D采用的是federated user的方式。
A错误在于没有login to IAM这个功能；C、E错误在于认证应该通过LDAP，而不是STS。

------------------

You run an ad-supported photo sharing website using S3 to serve photos to visitors of your site. At some
point you find out that other sites have been linking to the photos on your site, causing loss to your
business. What is an effective method to mitigate this?

A. Use CloudFront distributions for static content.

B. Remove public read access and use signed URLs with expiry dates.

C. Block the IPs of the offending websites in Security Groups.

D. Store photos on an EBS volume of the web server.

答案：B

参考文档：http://docs.aws.amazon.com/AmazonS3/latest/dev/ShareObjectPreSignedURL.html

解析：使用signed URL或者创建bucket policy都可以防止盗链。

-------------------

Your application is trying to upload a 6 GB file to Simple Storage Service and receive a "Your proposed
upload exceeds the maximum allowed object size." error message. What is a possible solution for this?

A. None, Simple Storage Service objects are limited to 5 GB

B. Use the multi-part upload API for this object

C. Use the large object upload API for this object

D. Contact support to increase your object size limit

E. Upload to a different region

答案:B

参考文档：http://docs.aws.amazon.com/AmazonS3/latest/dev/UploadingObjects.html

解析：所以S3能存放的最大对象是5T，但单个put操作支持的最大对象只有5G，超过5G的需要使用multi-part upload API上传。
