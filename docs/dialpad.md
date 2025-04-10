# `dialpad.cfc` Reference

#### `getCompany()`

Gets company information. *[Endpoint docs](https://developers.dialpad.com/reference/companyget)*

#### `toggleUserDND( required numeric id, required boolean do_not_disturb, numeric group_id, string group_type )`

Toggle DND status on or off for the given user. *[Endpoint docs](https://developers.dialpad.com/reference/userstoggle_dnd)*

#### `listCallCenters( string cursor, numeric office_id, string name_search, numeric limit )`

Lists all the call centers for the company. *[Endpoint docs](https://developers.dialpad.com/reference/callcenterslistall)*

#### `listCallCenterOperators( required numeric id )`

Lists all the operators for a call center. *[Endpoint docs](https://developers.dialpad.com/reference/callcentersoperatorsget)*

#### `removeCallCenterOperator( required numeric id, required numeric user_id )`

Removes an operator from a call center. *[Endpoint docs](https://developers.dialpad.com/reference/callcentersoperatorsdelete)*

#### `addCallCenterOperator( required numeric id, required numeric user_id )`

Adds an operator to a call center. Not all params are supported yet. *[Endpoint docs](https://developers.dialpad.com/reference/callcentersoperatorspost)*

#### `getCallCenterOperatorDutyStatus( required numeric id )`

Gets the duty status for a call center operator. *[Endpoint docs](https://developers.dialpad.com/reference/callcentersoperatorsgetdutystatus)*

#### `updateCallCenterOperatorDutyStatus( required numeric id, string duty_status_reason, required boolean on_duty )`

Updates the duty status for a call center operator. *[Endpoint docs](https://developers.dialpad.com/reference/callcentersoperatorsdutystatus)*

#### `listOffices( string cursor, numeric limit )`

Lists all the offices that are accessible using your api key. *[Endpoint docs](https://developers.dialpad.com/reference/officeslist)*

#### `listOfficeOffDutyStatuses( required numeric id )`

Lists off-duty status values. *[Endpoint docs](https://developers.dialpad.com/reference/officesoffdutystatusesget)*

#### `sendSMS( string channel_hashtag, boolean infer_country_code, string media, numeric sender_group_id, string sender_group_type, string text, array to_numbers, required numeric user_id )`

Sends an SMS message to a phone number or to a Dialpad channel on behalf of a user. The parameter `sender_group_type` is sender group's type (i.e. office, department, or callcenter). *[Endpoint docs](https://developers.dialpad.com/reference/smssend)*

#### `createOrUpdateContact( string company_name, array emails, string extension, required string first_name, string job_title, required string last_name, array phones, required string uid, array urls )`

Creates a new shared contact with uid. The parameter `phones` are the contacts phone numbers. The numbers must be in e164 format. The first number in the list is the contact's primary phone. *[Endpoint docs](https://developers.dialpad.com/reference/contactscreate_with_uid)*

#### `createCallEventSubscription( array call_states=["all"], boolean enabled, required string webhook_id, boolean group_calls_only, numeric target_id, string target_type )`

Creates a call event subscription. The parameter `call_states` declares the states for which call events are sent. You can find a list of call states here: https://developers.dialpad.com/docs/call-events-logging#call-states. If you do not specify any call states, the subscription will receive all call events. The parameter `target_id` can be used to scope the events only to the calls to/from that target. *[Endpoint docs](https://developers.dialpad.com/reference/webhook_call_event_subscriptioncreate)*

#### `deleteCallEventSubscription( required numeric id )`

Deletes a call event subscription by id. *[Endpoint docs](https://developers.dialpad.com/reference/webhook_call_event_subscriptiondelete)*

#### `listCallEventSubscriptions( string cursor, numeric limit, numeric target_id, string target_type )`

Lists all the call event subscriptions of a company or of a target. *[Endpoint docs](https://developers.dialpad.com/reference/webhook_call_event_subscriptionlist)*

#### `createSMSEventSubscription( string direction="all", boolean enabled, required string webhook_id, numeric target_id, string target_type )`

Creates an SMS event subscription. The parameter `direction` is the SMS direction this event subscription will be triggered for. Can be "all", "inbound", or "outbound". Defaults to "all". The parameter `target_id` can be used to scope the events only to the SMS to/from that target. *[Endpoint docs](https://developers.dialpad.com/reference/webhook_sms_event_subscriptioncreate)*

#### `deleteSMSEventSubscription( required numeric id )`

Deletes an SMS event subscription by id. *[Endpoint docs](https://developers.dialpad.com/reference/webhook_sms_event_subscriptiondelete)*

#### `listSMSEventSubscriptions( string cursor, numeric limit, numeric target_id, string target_type )`

Lists all the SMS event subscriptions of a company or of a target. *[Endpoint docs](https://developers.dialpad.com/reference/webhook_sms_event_subscriptionlist)*

#### `getTranscript( required any call_id )`

Gets a transcript by call_id. *[Endpoint docs](https://developers.dialpad.com/reference/transcriptsget)*

#### `getUser( required any id )`

Gets a user by id. *[Endpoint docs](https://developers.dialpad.com/reference/usersget)*

#### `listUsers( string cursor, string state, numeric limit, string email )`

Lists company users, optionally filtering by email. The parameter `state` filters results by the specified user state (e.g. active, suspended, deleted). *[Endpoint docs](https://developers.dialpad.com/reference/userslist)*

#### `createWebhook( required string hook_url, string secret="[runtime expression]" )`

Creates a new webhook for your company. *[Endpoint docs](https://developers.dialpad.com/reference/webhookscreate)*

#### `getWebhook( required numeric id )`

Gets a webhook by id. *[Endpoint docs](https://developers.dialpad.com/reference/webhooksget)*

#### `listWebhooks( string cursor, numeric limit )`

Lists all the webhooks that are associated with the company. *[Endpoint docs](https://developers.dialpad.com/reference/webhookslist)*

#### `deleteWebhook( required numeric id )`

Deletes a webhook by id. *[Endpoint docs](https://developers.dialpad.com/reference/webhooksdelete)*

#### `decodeWebhook( required any body, string secret="[runtime expression]" )`

Can be used to decode a webhook payload from Dialpad.

#### `encodeWebhook( required any payload, string secret="[runtime expression]" )`

Can be used to encode a webhook payload back into the format received from Dialpad.

#### `getWebhookSecret()`

Returns the webhookSecret the component is using as its default.

