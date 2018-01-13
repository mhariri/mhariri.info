+++
date = "2018-01-13T00:00:00+01:00"
draft = false
description = "Extracting the service API from Telenor android app"
keywords = ["Telenor", "API", "Decompile", "Android", "Call forwarding"]
title = "Telenor Subscriber Open(ed) API"
type = "post"
+++



#### Intro
For [vphone](https://vphone.io), I've been looking for an operator that allows
call forwarding for pre-paid SIM cards. After testing them all, it seems Telenor
is the only one in Sweden that allows that.

Unfortunately, I had a few issues
with their service: first problem was that I could not move my number to
Telenor, as their website does not allow that(it claims it can, but it doesn't work).
Customer service told me to first
order a SIM card and then move my number to that. The second problem was that unconditional
call forwarding does not work for calls made from non-telenor subscribers(could be
just for prepaid cards). So I had to use the no-answer call forwarding with the
shortest wait possible.

The good side of their service is that they have a nice [android app](https://play.google.com/store/apps/details?id=se.telenor.mytelenor&hl=en) that allows
users to manage different settings of their subscription, including the call forwarding settings.

So here is how I bypassed the app UX restrictions to setup the call forwarding wait
to shortest value.



#### Decompiling the Android App
First, I had to get the APK for the app. A search on google gave me this: [https://apkpure.com/my-telenor-se/se.telenor.mytelenor](https://apkpure.com/my-telenor-se/se.telenor.mytelenor)

I was surprised to see that decompilation was a piece of cake through online services:
[http://www.javadecompilers.com/apk](http://www.javadecompilers.com/apk)

After decompilation, I downloaded the zip file to investigate the sources locally.

#### Extracting the API

Looking through the sources, I could see the app is well written and the service and UI are cleanly separated, making it very easy to follow how it works. To be able to send the first request, the most interesting file is com/telenor/app/mytelenor/common/communication/requests/HttpRequest.java
which contains the logic of sending a simple request to the backend:

{{< highlight java >}}
connection.setRequestProperty(ApiConstants.HEADER_X_VERSION, ApiConstants.API_VERSION);
connection.setRequestProperty(ApiConstants.X_TELENOR_VERSION, ApiConstants.API_VERSION);
connection.setRequestProperty(ApiConstants.ACCEPT_TYPE_LANGUAGE, Locale.getDefault().getLanguage());
connection.setRequestProperty("Content-Type", getContentType());
connection.setRequestProperty("Accept", getAcceptType());
AuthHeader authHeader = getEncodedAuthHeader(ApiConstants.BASIC_HTTP_USERNAME + (useAuth() ? "|" + SessionVariables.getInstance().getUsername() : ""), getApiPassword() + (useAuth() ? "|" + SessionVariables.getInstance().getPassword() : ""));
connection.setRequestProperty(authHeader.getName(), authHeader.getValue());
{{< /highlight >}}

Based on that, here is my first request:
```nohighlight
$ http -v -a "knowit|me@he.re:knowit_prod|****" GET "https://api.telenor.se/c/users/me@he.re/basic" X-version:1.0 x-telenor-version:1.0
GET /c/users/me@he.re/basic HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Authorization: Basic ********
Connection: keep-alive
Host: api.telenor.se
User-Agent: HTTPie/0.9.8
X-version: 1.0
x-telenor-version: 1.0



HTTP/1.1 200 OK
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Cache-Control: max-age=600
Connection: close
Content-Encoding: gzip
Content-Length: 455
Content-Type: application/json;charset=UTF-8
Date: Sat, 13 Jan 2018 12:50:14 GMT
Expires: 0
Expires: Sat, 13 Jan 2018 12:50:14 GMT
Pragma: no-cache
Server: Apache
Vary: Accept-Encoding
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-Powered-By: Telenor Application Operations D=127615
X-XSS-Protection: 1; mode=block

{
    "email": "me@he.re",
    "subscriptions": [
        {
            "errorMessages": null,
            "msisdn": "46738966872",
            "subscriptionBasic": {
  ....
          }
        }
    ],
    "username": "hgghgfghbfdd"
}
```

The username and password are prefixed by `knowit|` and `knowit_prod|` respectively.
So just replace `me@he.re` with the email address and `****` with the password
that you used when registering the Telenor app.

And to get the call forwarding settings, one can use:
```nohighlight
http -v -a "knowit|me@he.re:knowit_prod|*****" GET "https://api.telenor.se/c/users/me@he.re/46738966872/callforward/v2" X-version:1.0 x-telenor-version:1.0
```
To set the minimum wait time for no-answer call forwarding:

```nohighlight
http -v -a "knowit|me@he.re:knowit_prod|*****" PUT "https://api.telenor.se/c/users/me@he.re/46738966872/callforward/v2/46108848348/cfna/5" X-version:1.0 x-telenor-version:1.0
```

The service only accepts a wait value that is a multiplier of 5 and bigger than 0.
It seems if you have unconditional call forwarding enabled, you will got a "TemporaryError" error from the above call. To fix that, just use the app and set the wait time to 2 rings to enable no-answer call forwarding and then call the API again to decrease the wait time.

Here is the full list of endpoints of Telenor API:
{{< highlight java >}}
public static final String ACTION_AVATAR = "/c/users/username/msisdn/avatar";
public static final String ACTION_CALL_FORWARD_DEACTIVATE = "/c/users/username/msisdn/callforward/v2/deactivate/type";
public static final String ACTION_CALL_FORWARD_SETTINGS = "/c/users/username/msisdn/callforward/v2";
public static final String ACTION_DELETE_AVATAR_FOR_MEMBER = "/c/users/username/msisdn/avatar";
public static final String ACTION_DELETE_CALL_FORWARD = "/c/users/username/msisdn/callforward/v2/deactivate/type";
public static final String ACTION_DELETE_ORDER_SERVICE = "/c/users/username/msisdn/services/serviceId";
public static final String ACTION_GET_ACCESSES = "/c/logaccess/username";
public static final String ACTION_GET_AGREEMENTS = "/c/users/username/msisdn/agreements";
public static final String ACTION_GET_AGREEMENT_BY_ID = "/c/users/username/msisdn/agreements/agreementId";
public static final String ACTION_GET_ALL_SERVICES = "/c/users/username/msisdn/services";
public static final String ACTION_GET_AVATAR = "/c/users/username/msisdn/avatar";
public static final String ACTION_GET_CALL_DETAILS = "/c/users/username/msisdn/invoices/trafficdetails";
public static final String ACTION_GET_CALL_DETAILS_PDF = "/c/users/username/msisdn/calldetails/invoiceid/pdf";
public static final String ACTION_GET_CALL_FORWARD_SETTINGS = "/c/users/username/msisdn/callforward/v2";
public static final String ACTION_GET_CAMPAIGN_GIVE_AWAY_DATA = "/c/users/username/msisdn/campaign/giveawaydata";
public static final String ACTION_GET_CONSENTS = "/c/users/username/msisdn/privacy/consents";
public static final String ACTION_GET_CONSENTS_FOR_PERSON = "/c/users/username/msisdn/privacy/consent/ssn";
public static final String ACTION_GET_CONSENT_TOGGLE = "/c/users/username/msisdn/privacy/display";
public static final String ACTION_GET_EMAIL_EXIST = "/c/email/emailaddress/exists";
public static final String ACTION_GET_INVOICES = "/c/users/username/msisdn/invoices/18";
public static final String ACTION_GET_INVOICE_DETAILS = "/c/users/username/msisdn/invoices/details/invoiceid";
public static final String ACTION_GET_INVOICE_PDF = "/c/users/username/msisdn/invoices/invoiceid/pdf";
public static final String ACTION_GET_ONE_TIME_PASSWORD = "/c/password/identifier/sms";
public static final String ACTION_GET_OTP_FOR_REGISTER = "/c/users/username/msisdn/sms";
public static final String ACTION_GET_POSTPAID_BALANCE = "/c/users/username/msisdn/balance/postpaid";
public static final String ACTION_GET_PREPAID_BALANCE = "/c/users/username/msisdn/balance/prepaid";
public static final String ACTION_GET_RATINGS = "/c/lograting/username";
public static final String ACTION_GET_REFILL_HISTORY = "/c/users/username/msisdn/balance/refillhistory";
public static final String ACTION_GET_SERVICE = "/c/users/username/msisdn/services/serviceId";
public static final String ACTION_GET_SERVICE_FEE_DETAILS = "/c/users/username/msisdn/serviceFeeDetails";
public static final String ACTION_GET_SUBSCRIPTION_INFORMATION_BASIC = "/c/users/username/msisdn/basic";
public static final String ACTION_GET_SUBSCRIPTION_NOTIFICATION_SETTINGS = "/c/users/username/msisdn/notifications/postpaid";
public static final String ACTION_GET_TOTAL_SURF_DATA = "/c/users/username/msisdn/balance/shareable";
public static final String ACTION_GET_USERNAME_EXIST = "/c/users/username/exists";
public static final String ACTION_GET_USER_INFORMATION_BASIC = "/c/users/username/basic";
public static final String ACTION_GET_VERSION_CHECK_ANDROID = "/c/versioncheck/apiuser/appVersion/android";
public static final String ACTION_GET_VERSION_CHECK_IOS = "/c/versioncheck/apiuser/appVersion/ios";
public static final String ACTION_POST_RAITING = "/c/lograting/username/appSection/appVersion/ratingvalue/msisdn";
public static final String ACTION_POST_REGISTER_USER = "/c/users";
public static final String ACTION_PUT_ACTIVATE_SURF_RESTRICTION = "/c/users/username/msisdn/shareable/restriction";
public static final String ACTION_PUT_AVATAR = "/c/users/username/msisdn/avatar";
public static final String ACTION_PUT_CALL_FORWARD_SETTINGS = "/c/users/username/msisdn/callforward/v2";
public static final String ACTION_PUT_CFNA_SETTINGS = "/c/users/username/msisdn/callforward/v2/fnum/cfna/time";
public static final String ACTION_PUT_CFNR_CFU_CFB_SETTINGS = "/c/users/username/msisdn/callforward/v2/fnum/type";
public static final String ACTION_PUT_CONSENT = "/c/users/username/msisdn/privacy/consent/ssn";
public static final String ACTION_PUT_CW_SETTINGS = "/c/users/username/msisdn/callforward/v2/callwaiting";
public static final String ACTION_PUT_NEW_ALIAS = "/c/users/username/msisdn/alias/newAlias";
public static final String ACTION_PUT_NEW_MEMBER_TYPE = "/c/users/username/msisdn/shareable/profile/memberType";
public static final String ACTION_PUT_NEW_PASSWORD = "/c/password/username";
public static final String ACTION_PUT_ORDER_SERVICE = "/c/users/username/msisdn/services/serviceId";
public static final String ACTION_PUT_ORDER_SERVICE_LEVEL = "/c/users/username/msisdn/services/serviceId/level";
public static final String ACTION_PUT_SUBSCRIPTION_NOTIFICATION_SETTINGS = "/c/users/username/msisdn/notifications/postpaid";
public static final String ACTION_PUT_SURF_DATA_REFILL = "/c/users/username/msisdn/shareable/refill/refillId";
public static final String ACTION_PUT_SURF_RESTRICTION = "/c/users/username/msisdn/shareable/restriction/volume";
public static final String ACTION_SERVICE = "/c/users/username/msisdn/services/serviceId";
public static final String ACTION_SUBSCRIPTION_NOTIFICATION_SETTINGS = "/c/users/username/msisdn/notifications/postpaid";
{{< /highlight >}}
