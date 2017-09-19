/**
 * @singleton      true
 * @presideService true
 *
 */
component {

// CONSTRUCTOR
	/**
	 * @tokenDao.inject presidecms:object:simple_sso_user_token
	 *
	 */
	public any function init( required any tokenDao ) {
		_setTokenDao( arguments.tokenDao );

		return this;
	}

// PUBLIC API METHODS
	public string function createToken(
		  string owner   = $getWebsiteLoggedInUserId()
		, date   expires = _getDefaultExpiry()
	) {
		var token = _generateToken();

		_getTokenDao().insertData({
			  token   = token
			, owner   = arguments.owner
			, expires = arguments.expires
		});

		return token;
	}

	public string function getTokenOwner( required string token ) {
		var dao         = _getTokenDao();
		var tokenRecord = dao.selectData(
			  filter = { token = arguments.token }
			, selectFields = [ "id", "owner", "expires" ]
		);

		if ( tokenRecord.recordCount ) {
			dao.deleteData( tokenRecord.id );

			if ( !_isExpired( tokenRecord.expires ) ) {
				return tokenRecord.owner;
			}
		}

		return "";
	}

// PRIVATE HELPERS
	private date function _getDefaultExpiry() {
		return DateAdd( 'n', 2, Now() );
	}

	private boolean function _isExpired( required date expiryDate ) {
		return DateDiff( 's', arguments.expiryDate, Now() ) > 0;
	}

	private string function _generateToken() {
		var chars        = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var charCount    = chars.len();
		var targetLength = 32;
		var token        = "";

		do {
			token &= chars[ RandRange( 1, charCount, "SHA1PRNG" ) ];
		} while( token.len() < targetLength );

		return token;
	}

// GETTERS AND SETTERS
	private any function _getTokenDao() {
		return _tokenDao;
	}
	private void function _setTokenDao( required any tokenDao ) {
		_tokenDao = arguments.tokenDao;
	}
}