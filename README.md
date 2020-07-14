# Dot Net - (407) Proxy Authentication Required Error

Since rebranded 'Microsoft 365' no longer has Device Based Activation, this is now no longer required for deployments. Though it can be helpful if you have another application that uses Dot Net to contact the web. I have renamed the title to reflect this, the example I have left as is in case anyone wants to adapt the coding...

So, you've followed the instructions for deploying Office 365 Pro Plus with Device Based Activation... most likely from an online instruction, such as [this awesome one…](https://sysadminedu.wordpress.com/2017/01/07/step-by-step-guide-to-deploying-office-365-pro-plus-with-device-based-activation-with-sccm/) but, when you come to running the OPPTransition.exe you get a problem that looks a little like this one...

```C:\O365>OPPTransition.exe -Tenant TENANTUUID -Key KEYUUID -Domain contoso.onmicrosoft.com
00:00:00 | OPPTransition started - 1.1.12.95
00:00:00 | Reading arguments
00:00:01 | Args: -tenant TENANTUUID -domain contoso.onmicrosoft.com
00:00:01 | Args Valid
00:00:01 | Nonce: RANDOMTEXTHERE
00:00:01 | Start not logged
00:00:01 | One or more errors occurred.
00:00:01 | System.AggregateException: One or more errors occurred. ---> System.Net.Http.HttpRequestException: An error occurred while sending the request. ---> System.Net.WebException: The remote server returned an error: (407) Proxy Authentication Required.
   at System.Net.HttpWebRequest.EndGetResponse(IAsyncResult asyncResult)
   at System.Net.Http.HttpClientHandler.GetResponseCallback(IAsyncResult ar)
   --- End of inner exception stack trace ---
   --- End of inner exception stack trace ---
   at System.Threading.Tasks.Task`1.GetResultCore(Boolean waitCompletionNotification)
   at OPP_Transition.HttpHelperClient.GetResponseWithStatus(String Uri, Status Status)
---> (Inner Exception #0) System.Net.Http.HttpRequestException: An error occurred while sending the request. ---> System.Net.WebException: The remote server returned an error: (407) Proxy Authentication Required.
   at System.Net.HttpWebRequest.EndGetResponse(IAsyncResult asyncResult)
   at System.Net.Http.HttpClientHandler.GetResponseCallback(IAsyncResult ar)
   --- End of inner exception stack trace ---<---

00:00:02 | PreflightCheck failed - wait: 505
```

The problem is that you're using an AD user based web filtering system, and the program is unable to transfer information about who is logged on to authenticate to the proxy server... So, how do you get around that?

If you edit the Dot Net machine.config file (i.e. `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Co nfig\machine.config`) you can add a section in to place a proxy server that does not use AD based filtering. Before the `</configuration>` section, enter the following line, changing **PROXYDETAILSHERE:PORT** with your non AD user based web filtering system and proxy.
`<system.net><defaultProxy enabled="true" useDefaultCredentials="true"><proxy usesystemdefault="true" proxyaddress="PROXYDETAILSHERE:PORT" bypassonlocal="true"/></defaultProxy></system.net>`

Although, I find it's easier to do this in a script, and to reset it back afterwards (just in case).
