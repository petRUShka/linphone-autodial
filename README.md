# linphone-autodial
Script helps you to auto-dial to some recipients (for example several fixed phone numbers) via your [SIP](https://en.wikipedia.org/wiki/Session_Initiation_Protocol) provider and [Linphone open-source voip client](http://www.linphone.org/).

Firstly you should install Linphone and configure it with your SIP-account credentials.
Then you should run the script like this

```bash
./auto-dial.sh <call recipient 1> <call recipient 2> <...>
```

or if you want to setup pause interval which is 2 seconds by default you should run like this:

```bash
SLEEP_INTERVAL=<interval between attempts in seconds> ./auto-dial.sh <call recipient 1> <call recipient 2> <...>
```

Feel free to improve the script and to send pull requests and issues.
