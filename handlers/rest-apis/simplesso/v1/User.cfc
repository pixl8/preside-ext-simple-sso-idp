/**
 * @restUri /user/{token}/
 *
 */
component {

	property name="simpleSsoService" inject="simpleSsoService";
	property name="retrievalHandler" inject="coldbox:setting:simplesso.retrievalHandler";

	private void function get( required string token ) {
		var userId   = simpleSsoService.getTokenOwner( arguments.token );
		var userData = {};

		if ( userId.len() ) {
			userData = runEvent(
				  event          = retrievalHandler
				, private        = true
				, prepostExempt  = true
				, eventArguments = { userId = userId }
			);
		}

		if ( userData.count() ) {
			restResponse.setData( userData );
		} else {
			restResponse.setData( { error="Token not found, or expired", code=404 } ).setStatus( 404, "Token not found, or expired" );
		}

	}
}