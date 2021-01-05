/**
 * Stores expirable tokens for use with simple sign on
 *
 * @nolabel   true
 * @versioned false
 *
 */
component {
	property name="expires" type="date"   dbtype="datetime"              indexes="expires"  required=true;
	property name="token"   type="string" dbtype="varchar"  maxlength=32 indexes="token"    required=true;

	property name="owner" relationship="many-to-one" relatedto="website_user"               required=true  ondelete="cascade";
}