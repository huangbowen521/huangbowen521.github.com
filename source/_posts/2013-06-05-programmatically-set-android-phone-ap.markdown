---
layout: post
title: 调用API设置安卓手机的Access Point
date: 2013-06-05 12:04
comments: true
categories: Android
tags: [AP, Android] 
---


{% img /images/android.jpeg %}


最近在做一个小的应用，需要通过程序设置安卓手机的AP（Access point, 即将手机变为一个移动热点，其他机器能够通过wifi连接到此手机）。原以为很简单的一个东西，还是花费了一番周折，最终还是搞定了。

<!-- more -->

配置AP的选项是属于配置wifi的一部分，所以他们都在WifiManager这个类中。
获取当前系统的WifiManager实例的方法是:

```java

WifiManager wifi = (WifiManager) getSystemService(Context.WIFI_SERVICE); 
```

此类中有几个关键方法用来设置AP，但是它们都是被隐藏的，我们无法直接调用，所以只有通过反射的方式来调用。

获取AP当前状态的方法是:

```java
private Boolean getApState(WifiManager wifi) throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        Method method = wifi.getClass().getMethod("isWifiApEnabled");
        return (Boolean) method.invoke(wifi);
    }
```
配置AP要使用到WifiConfiguration这个类，以下是设置的一个AP。

```java

private WifiConfiguration getApConfiguration() {
        WifiConfiguration apConfig = new WifiConfiguration();
        //配置热点的名称
        apConfig.SSID = "yourId";
        apConfig.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN);
        apConfig.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
        apConfig.allowedProtocols.set(WifiConfiguration.Protocol.RSN);
        apConfig.allowedProtocols.set(WifiConfiguration.Protocol.WPA);
        //配置热点的密码
        apConfig.preSharedKey = "yourPassword";
        return apConfig;
    }

```
应用AP配置并启用AP要使用另一个被隐藏的方法`setWifiApEnabled`。**需要注意的是启用AP前要将当前手机的wifi关闭，否则会启动失败。**

```java

    private void setWifiAp() {


        Method method = wifi.getClass().getMethod(
                "setWifiApEnabled", WifiConfiguration.class, Boolean.TYPE);

        wifi.setWifiEnabled(false);
        method.invoke(wifi, null, true);
    }

```

最后，一定要注意要在AndroidManifest.xml文件中设置几个权限。否则在调用API时会产生`java.lang.SecurityException: Permission Denied`的异常。
需要加入的权限如下：
```xml
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />

```

源码我已经放置到github上了，需要的请自行checkout。地址是：<https://github.com/huangbowen521/APSwitch>
 




