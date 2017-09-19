# Simple Single Sign On Identity Provider for Preside

[![Build Status](https://travis-ci.org/pixl8/preside-ext-simple-sso-idp.svg?branch=stable "Stable")](https://travis-ci.org/pixl8/preside-ext-simple-sso-idp)

This extension provides single sign on API for Preside applications using a simple and secure technique with easy to follow implementation details for client applications.

**IT REQUIRES PRESIDE 10.9 AND ABOVE**

## Installation

Install the extension to your application via either of the methods detailed below (Git submodule / CommandBox).

### CommandBox (box.json) method, prefered

From the root of your application, type the following command:

    box install preside-ext-simple-sso-idp

### Git Submodule method

From the root of your application, type the following command:

    git submodule add https://github.com/pixl8/preside-ext-simple-sso-idp.git application/extensions/preside-ext-simple-sso-idp

## Usage

The extension provides nothing more than a service layer API to generate one-time tokens for use with a SSO request to your external client. Configuration of your external client is, for now, left entirely to you.

SSO flow is as follows:

1. User visits handler in your application **that you create**, e.g. `/sso/clientx/`
2. Your custom handler checks that the user is logged in, if not: `event.accessDenied( reason="LOGIN_REQUIRED" )`
3. If logged in, your custom handler generates a one-time token using `SimpleSsoService.createToken()`
4. Your custom handler redirects the user to the configured client application endpoint (you could use a [preside system form](https://docs.presidecms.com/devguides/editablesystemsettings.html) for this)
5. The client application accepts the request and makes a server-to-server REST call to `yoursite.com/api/simplesso/v1/user/{token}/`, where `{token}` is the token passed in step 4.
6. The REST API validates the token and returns user details in a json object, or 404 if invalid

### Example handler

At `/handlers/Sso.cfc`:

```
component {

	// inject simpleSsoService that is provided by the extension
	property name="simpleSsoService" inject="simpleSsoService";

	public void function clientx( event, rc, prc ) {

		// login check
		if ( !isLoggedIn() ) {
			event.accessDenied( reason="LOGIN_REQUIRED" );
		}

		// get configured client endpoint for external system
		var clientXEndpoint = getSystemSetting( "clientx", "sso_endpoint" );

		// generate a one time SSO token and create a query string
		var qs = "token=" & simpleSsoService.createToken();

		// add query string to endpoint
		clientXEndpoint &= ( clientXEndpoint.find( '?' ) ? "&" : "?" ) & qs;

		// redirect user to endpoint, including token in query string
		setNextEvent( url=clientXEndpoint );
	}

}
```

### Example client code:

The following is an overly simplified example for demonstration purposes.

```
token = url.token ?: "";

http url="https://authprovider.site.com/api/simplesso/v1/user/#token#" username=apiSecretToken {}


userDetails = DeSerializeJson( cfhttp.fileContent );

// use userDetails to sign in...
```

### Configuring API clients to authenticate API calls

Firstly, ensure that you are running Preside 10.9 or above. Next, you need to ensure that you have the REST API manager enabled by adding the following line to your `Config.cfc` file:

```
settings.features.apiManager.enabled = true;
```

Next, login to the Preside admin and navigate to **System -> API Manager**. Here you can create API users and grant them access to the `/simplesso/v1` API. Each client application will get a generated token with which to authenticate - this will need to be supplied to external teams.

## Troubleshooting

Join the Preside team Slack where we'll be happy to help with any issues or unclear instructions.