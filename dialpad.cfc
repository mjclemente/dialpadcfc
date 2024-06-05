/**
* dialpadcfc
* Copyright 2022  Matthew J. Clemente, John Berquist
* Licensed under MIT (https://mit-license.org)
*/
component displayname="dialpadcfc" {

  variables._dialpadcfc_version = "0.0.6";

  public any function init(
    string apiKey        = "",
    string webhookSecret = "",
    string baseUrl       = "https://dialpad.com/api/v2",
    boolean includeRaw   = false,
    numeric httpTimeout  = 50
  ) {
    structAppend(variables, arguments);

    // map sensitive args to env variables or java system props
    var secrets = {"apiKey": "DIALPAD_APIKEY"};
    var system  = createObject("java", "java.lang.System");

    for( var key in secrets ){
      // arguments are top priority
      if( variables[key].len() ){
        continue;
      }

      // check environment variables
      var envValue = system.getenv(secrets[key]);
      if( !isNull(envValue) && envValue.len() ){
        variables[key] = envValue;
        continue;
      }

      // check java system properties
      var propValue = system.getProperty(secrets[key]);
      if( !isNull(propValue) && propValue.len() ){
        variables[key] = propValue;
      }
    }

    // declare file fields to be handled via multipart/form-data **Important** this is not applicable if payload is application/json
    variables.fileFields = [];

    return this;
  }

  /**
  * @docs https://developers.dialpad.com/reference/companyget
  * @hint Gets company information.
  */
  public struct function getCompany() {
    return apiCall("GET", "/company");
  }

  /**
  * @docs https://developers.dialpad.com/reference/userslist
  * @hint Lists company users, optionally filtering by email.
  */
  public struct function listUsers(
    string cursor,
    string state,
    boolean company_admin,
    numeric limit,
    string email,
    string number
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/users", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/userstoggle_dnd
  * @hint Toggle DND status on or off for the given user
  */
  public struct function toggleUserDND(
    required numeric id,
    required boolean do_not_disturb,
    numeric group_id,
    string group_type
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("PATCH", "/users/#arguments.id#/togglednd", {}, params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/callcenterslistall
  * @hint Lists all the call centers for the company.
  */
  public struct function listCallCenters(
    string cursor,
    numeric office_id,
    string name_search,
    numeric limit
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/callcenters", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/callcentersoperatorsget
  * @hint Lists all the operators for a call center.
  */
  public struct function listCallCenterOperators(required numeric id) {
    return apiCall("GET", "/callcenters/#arguments.id#/operators");
  }

  /**
  * @docs https://developers.dialpad.com/reference/callcentersoperatorsdelete
  * @hint Removes an operator from a call center.
  */
  public struct function removeCallCenterOperator(required numeric id, required numeric user_id ) {
    var payload = { "user_id": arguments.user_id };
    return apiCall("DELETE", "/callcenters/#arguments.id#/operators", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/callcentersoperatorspost
  * @hint Adds an operator to a call center. Not all params are supported yet.
  */
  public struct function addCallCenterOperator(required numeric id, required numeric user_id ) {
    var payload = { "user_id": arguments.user_id };
    return apiCall("POST", "/callcenters/#arguments.id#/operators", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/callcentersoperatorsgetdutystatus
  * @hint Gets the duty status for a call center operator.
  */
  public struct function getCallCenterOperatorDutyStatus(required numeric id) {
    return apiCall("GET", "/callcenters/operators/#arguments.id#/dutystatus");
  }

  /**
  * @docs https://developers.dialpad.com/reference/callcentersoperatorsdutystatus
  * @hint Updates the duty status for a call center operator.
  */
  public struct function updateCallCenterOperatorDutyStatus(
    required numeric id,
    string duty_status_reason,
    required boolean on_duty
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("PATCH", "/callcenters/operators/#arguments.id#/dutystatus", {}, params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/officeslist
  * @hint Lists all the offices that are accessible using your api key.
  */
  public struct function listOffices(string cursor, numeric limit) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/offices", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/officesoffdutystatusesget
  * @hint Lists off-duty status values.
  */
  public struct function listOfficeOffDutyStatuses(required numeric id) {
    return apiCall("GET", "/offices/#arguments.id#/offdutystatuses");
  }

  /**
  * @docs https://developers.dialpad.com/reference/smssend
  * @hint Sends an SMS message to a phone number or to a Dialpad channel on behalf of a user.
  * @sender_group_type is sender group's type (i.e. office, department, or callcenter).
  */
  public struct function sendSMS(
    string channel_hashtag,
    boolean infer_country_code,
    string media,
    numeric sender_group_id,
    string sender_group_type,
    string text,
    array to_numbers,
    required numeric user_id
  ) {
    var payload = extractNonNullArgs(arguments);
    return apiCall("POST", "/sms", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/contactscreate_with_uid
  * @hint Creates a new shared contact with uid.
  * @phones are the contacts phone numbers. The numbers must be in e164 format. The first number in the list is the contact's primary phone.
  */
  public struct function createOrUpdateContact(
    string company_name,
    array emails,
    string extension,
    required string first_name,
    string job_title,
    required string last_name,
    array phones,
    required string uid,
    array urls
  ) {
    var payload = extractNonNullArgs(arguments);
    return apiCall("PUT", "/contacts", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhook_call_event_subscriptioncreate
  * @hint Creates a call event subscription.
  * @call_states declares the states for which call events are sent. You can find a list of call states here: https://developers.dialpad.com/docs/call-events-logging#call-states. If you do not specify any call states, the subscription will receive all call events.
  * @target_id can be used to scope the events only to the calls to/from that target
  */
  public struct function createCallEventSubscription(
    array call_states = ["all"],
    boolean enabled,
    required string webhook_id,
    boolean group_calls_only,
    numeric target_id,
    string target_type
  ) {
    var payload = extractNonNullArgs(arguments);
    return apiCall("POST", "/subscriptions/call", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhook_call_event_subscriptiondelete
  * @hint Deletes a call event subscription by id.
  */
  public struct function deleteCallEventSubscription(required numeric id) {
    return apiCall("DELETE", "/subscriptions/call/#arguments.id#");
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhook_call_event_subscriptionlist
  * @hint Lists all the call event subscriptions of a company or of a target.
  */
  public struct function listCallEventSubscriptions(
    string cursor,
    numeric limit,
    numeric target_id,
    string target_type
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/subscriptions/call", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhook_sms_event_subscriptioncreate
  * @hint Creates an SMS event subscription.
  * @direction is the SMS direction this event subscription will be triggered for. Can be "all", "inbound", or "outbound". Defaults to "all".
  * @target_id can be used to scope the events only to the SMS to/from that target
  */
  public struct function createSMSEventSubscription(
    string direction = "all",
    boolean enabled,
    required string webhook_id,
    numeric target_id,
    string target_type
  ) {
    var payload = extractNonNullArgs(arguments);
    return apiCall("POST", "/subscriptions/sms", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhook_sms_event_subscriptiondelete
  * @hint Deletes an SMS event subscription by id.
  */
  public struct function deleteSMSEventSubscription(required numeric id) {
    return apiCall("DELETE", "/subscriptions/sms/#arguments.id#");
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhook_sms_event_subscriptionlist
  * @hint Lists all the SMS event subscriptions of a company or of a target.
  */
  public struct function listSMSEventSubscriptions(
    string cursor,
    numeric limit,
    numeric target_id,
    string target_type
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/subscriptions/sms", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/userslist
  * @hint Lists company users, optionally filtering by email.
  * @state filters results by the specified user state (e.g. active, suspended, deleted)
  */
  public struct function listUsers(
    string cursor,
    string state,
    numeric limit,
    string email
  ) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/users", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhookscreate
  * @hint Creates a new webhook for your company.
  */
  public struct function createWebhook(required string hook_url, string secret = variables.webhookSecret) {
    var payload = extractNonNullArgs(arguments);
    if( !arguments.secret.len() ){
      payload.delete("secret");
    }
    return apiCall("POST", "/webhooks", {}, payload);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhooksget
  * @hint Gets a webhook by id.
  */
  public struct function getWebhook(required numeric id) {
    return apiCall("GET", "/webhooks/#arguments.id#");
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhookslist
  * @hint Lists all the webhooks that are associated with the company.
  */
  public struct function listWebhooks(string cursor, numeric limit) {
    var params = extractNonNullArgs(arguments);
    return apiCall("GET", "/webhooks", params);
  }

  /**
  * @docs https://developers.dialpad.com/reference/webhooksdelete
  * @hint Deletes a webhook by id.
  */
  public struct function deleteWebhook(required numeric id) {
    return apiCall("DELETE", "/webhooks/#arguments.id#");
  }

  /**
  * @hint Can be used to decode a webhook payload from Dialpad
  */
  public struct function decodeWebhook(required any body, string secret = variables.webhookSecret) {
    var payload = arguments.body;
    if( isBinary(arguments.body) ){
      payload = charsetEncode(arguments.body, "utf-8");
    }

    if( payload.listLen(".") != 3 ){
      cfthrow(type = "Invalid JWT Payload", message = "Payload must contain 3 segments");
    }

    var header       = payload.listGetAt(1, ".");
    var parsedHeader = parseJwtElement(header);
    // make sure the algorithm is supported
    if( parsedHeader.alg != "HS256" ){
      cfthrow(type = "Invalid JWT Token", message = "Algorithm not supported");
    }

    var message       = payload.listGetAt(2, ".");
    var parsedMessage = parseJwtElement(message);
    var signature     = payload.listGetAt(3, ".");
    var input         = header & "." & message;

    // verify the signature
    if( signature != encodeInput(input, arguments.secret) ){
      cfthrow(type = "Invalid JWT Token", message = "Signature does not match");
    }

    return parsedMessage;
  }


  // ===========================================================================
  // PRIVATE FUNCTIONS
  // ===========================================================================

  private struct function extractNonNullArgs(required struct args) {
    var params = {};
    for( var key in arguments.args ){
      if( !isNull(arguments.args[key]) ){
        // lcased to account for ACF capitalization of struct keys
        params[lCase(key)] = arguments.args[key];
      }
    }

    return params;
  }

  private string function encodeInput(required string input, string secret = variables.webhookSecret) {
    return urlSafeBase64Encode(binaryDecode(hmac(arguments.input, arguments.secret, "HmacSHA256", "utf-8"), "hex"));
  }

  private string function urlSafeBase64Decode(str) {
    var bytes = createObject("java", "java.util.Base64").getUrlDecoder().decode(arguments.str);
    return createObject("java", "java.lang.String").init(bytes);
  }

  private string function urlSafeBase64Encode(str) {
    return createObject("java", "java.util.Base64")
      .getUrlEncoder()
      .withoutPadding()
      .encodeToString(isBinary(arguments.str) ? arguments.str : arguments.str.getBytes("UTF-8"));
  }

  private struct function parseJwtElement(required string input) {
    var decoded = urlSafeBase64Decode(arguments.input);
    return deserializeJSON(decoded);
  }

  private struct function apiCall(
    required string httpMethod,
    required string path,
    struct queryParams = {},
    any payload        = "",
    struct headers     = {}
  ) {
    var fullApiPath    = variables.baseUrl & path;
    var requestHeaders = getBaseHttpHeaders();
    requestHeaders.append(headers, true);

    var requestStart = getTickCount();
    var apiResponse  = makeHttpRequest(
      httpMethod  = httpMethod,
      path        = fullApiPath,
      queryParams = queryParams,
      headers     = requestHeaders,
      payload     = payload
    );

    var result = {
      "responseTime": getTickCount() - requestStart,
      "statusCode"  : listFirst(apiResponse.statuscode, " "),
      "statusText"  : listRest(apiResponse.statuscode, " "),
      "headers"     : apiResponse.responseheader
    };

    var parsedFileContent = {};

    // Handle response based on mimetype
    var mimeType = apiResponse.mimetype ?: requestHeaders["Content-Type"];

    if( mimeType == "application/json" && isJSON(apiResponse.fileContent) ){
      parsedFileContent = deserializeJSON(apiResponse.fileContent);
    } else if( mimeType.listLast("/") == "xml" && isXML(apiResponse.fileContent) ){
      parsedFileContent = xmlToStruct(apiResponse.fileContent);
    } else {
      parsedFileContent = apiResponse.fileContent;
    }

    // can be customized by API integration for how errors are returned
    // if ( result.statusCode >= 400 ) {}

    // stored in data, because some responses are arrays and others are structs
    result["data"] = parsedFileContent;

    if( variables.includeRaw ){
      result["raw"] = {
        "method"  : uCase(httpMethod),
        "path"    : fullApiPath,
        "params"  : parseQueryParams(queryParams),
        "payload" : parseBody(payload),
        "response": apiResponse.fileContent
      };
    }

    return result;
  }

  private struct function getBaseHttpHeaders() {
    return {
      "Accept"       : "application/json",
      "Content-Type" : "application/json",
      "User-Agent"   : "dialpadcfc/#variables._dialpadcfc_version# (ColdFusion)",
      "Authorization": "Bearer #variables.apiKey#"
    };
  }

  private any function makeHttpRequest(
    required string httpMethod,
    required string path,
    struct queryParams = {},
    struct headers     = {},
    any payload        = ""
  ) {
    var result = "";

    var fullPath = path & (
      !queryParams.isEmpty()
       ? ("?" & parseQueryParams(queryParams, false))
       : ""
    );

    cfhttp(url = fullPath, method = httpMethod, result = "result", timeout = variables.httpTimeout) {
      if( isJsonPayload(headers) ){
        var requestPayload = parseBody(payload);
        if( isJSON(requestPayload) ){
          cfhttpparam(type = "body", value = requestPayload);
        }
      } else if( isFormPayload(headers) ){
        headers.delete("Content-Type"); // Content Type added automatically by cfhttppparam

        for( var param in payload ){
          if( !variables.fileFields.contains(param) ){
            cfhttpparam(type = "formfield", name = param, value = payload[param]);
          } else {
            cfhttpparam(type = "file", name = param, file = payload[param]);
          }
        }
      }

      // handled last, to account for possible Content-Type header correction for forms
      var requestHeaders = parseHeaders(headers);
      for( var header in requestHeaders ){
        cfhttpparam(type = "header", name = header.name, value = header.value);
      }
    }
    return result;
  }

  /**
  * @hint convert the headers from a struct to an array
  */
  private array function parseHeaders(required struct headers) {
    var sortedKeyArray = headers.keyArray();
    sortedKeyArray.sort("textnocase");
    var processedHeaders = sortedKeyArray.map(function( key ) {
      return {name: key, value: trim(headers[key])};
    });
    return processedHeaders;
  }

  /**
  * @hint converts the queryparam struct to a string, with optional encoding and the possibility for empty values being pass through as well
  */
  private string function parseQueryParams(
    required struct queryParams,
    boolean encodeQueryParams  = true,
    boolean includeEmptyValues = true
  ) {
    var sortedKeyArray = queryParams.keyArray();
    sortedKeyArray.sort("text");

    var queryString = sortedKeyArray.reduce(function( queryString, queryParamKey ) {
      var encodedKey = encodeQueryParams
       ? encodeUrl(queryParamKey)
       : queryParamKey;
      if( !isArray(queryParams[queryParamKey]) ){
        var encodedValue = encodeQueryParams && len(queryParams[queryParamKey])
         ? encodeUrl(queryParams[queryParamKey])
         : queryParams[queryParamKey];
      } else {
        var encodedValue = encodeQueryParams && arrayLen(queryParams[queryParamKey])
         ? encodeUrl(serializeJSON(queryParams[queryParamKey]))
         : queryParams[queryParamKey].toList();
      }
      return queryString.listAppend(
        encodedKey & (includeEmptyValues || len(encodedValue) ? ("=" & encodedValue) : ""),
        "&"
      );
    }, "");

    return queryString.len() ? queryString : "";
  }

  private string function parseBody(required any body) {
    if( isStruct(body) || isArray(body) ){
      return serializeJSON(body);
    } else if( isJSON(body) ){
      return body;
    } else {
      return "";
    }
  }

  private string function encodeUrl(required string str, boolean encodeSlash = true) {
    var result = replaceList(urlEncodedFormat(str, "utf-8"), "%2D,%2E,%5F,%7E", "-,.,_,~");
    if( !encodeSlash ){
      result = replace(result, "%2F", "/", "all");
    }
    return result;
  }

  /**
  * @hint helper to determine if body should be sent as JSON
  */
  private boolean function isJsonPayload(required struct headers) {
    return headers["Content-Type"] == "application/json";
  }

  /**
  * @hint helper to determine if body should be sent as form params
  */
  private boolean function isFormPayload(required struct headers) {
    return arrayContains(["application/x-www-form-urlencoded", "multipart/form-data"], headers["Content-Type"]);
  }

  /**
  *
  * Based on an (old) blog post and UDF from Raymond Camden
  * https://www.raymondcamden.com/2012/01/04/Converting-XML-to-JSON-My-exploration-into-madness/
  *
  */
  private struct function xmlToStruct(required any x) {
    if( isSimpleValue(x) && isXML(x) ){
      x = xmlParse(x);
    }

    var s = {};

    if( xmlGetNodeType(x) == "DOCUMENT_NODE" ){
      s[structKeyList(x)] = xmlToStruct(x[structKeyList(x)]);
    }

    if( structKeyExists(x, "xmlAttributes") && !structIsEmpty(x.xmlAttributes) ){
      s.attributes = {};
      for( var item in x.xmlAttributes ){
        s.attributes[item] = x.xmlAttributes[item];
      }
    }

    if( structKeyExists(x, "xmlText") && x.xmlText.trim().len() ){
      s.value = x.xmlText;
    }

    if( structKeyExists(x, "xmlChildren") ){
      for( var xmlChild in x.xmlChildren ){
        if( structKeyExists(s, xmlChild.xmlname) ){
          if( !isArray(s[xmlChild.xmlname]) ){
            var temp            = s[xmlChild.xmlname];
            s[xmlChild.xmlname] = [temp];
          }

          arrayAppend(s[xmlChild.xmlname], xmlToStruct(xmlChild));
        } else {
          if( structKeyExists(xmlChild, "xmlChildren") && arrayLen(xmlChild.xmlChildren) ){
            s[xmlChild.xmlName] = xmlToStruct(xmlChild);
          } else if( structKeyExists(xmlChild, "xmlAttributes") && !structIsEmpty(xmlChild.xmlAttributes) ){
            s[xmlChild.xmlName] = xmlToStruct(xmlChild);
          } else {
            s[xmlChild.xmlName] = xmlChild.xmlText;
          }
        }
      }
    }

    return s;
  }

}
