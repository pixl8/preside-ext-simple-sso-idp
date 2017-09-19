component {

	property name="userDao" inject="presidecms:object:website_user";

	private struct function getUser( event, rc, prc, userId="" ) {
		var userRecord = userDao.selectData( id=arguments.userId, selectFields=[
			  "login_id"
			, "email_address"
			, "display_name"
		] );

		for( var u in userRecord ) {
			return u;
		}

		return {};
	}
}