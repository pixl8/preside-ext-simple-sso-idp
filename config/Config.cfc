component {

	public void function configure( required struct config ) {
		var settings = arguments.config.settings ?: {};

		settings.simpleSso = settings.simplesso ?: {};
		settings.simpleSso.retrievalHandler = settings.simpleSso.retrievalHandler ?: "simplesso.getUser";

		settings.rest.apis[ "/simplesso/v1" ] = { authProvider="token", description="Rest API for simple Single Sign on (<a href=""https://github.com/pixl8/preside-ext-simple-sso-idp"">https://github.com/pixl8/preside-ext-simple-sso-idp</a>)" };
	}
}