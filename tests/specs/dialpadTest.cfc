component extends="testbox.system.BaseSpec" {

  /*********************************** LIFE CYCLE Methods ***********************************/

  function beforeAll() {
    baseUrl           = "http://127.0.0.1:52558/testapi";
    variables.dialpad = new dialpad(
      apiKey        = "test_api_key",
      webhookSecret = "test_secret",
      baseUrl       = baseUrl,
      includeRaw    = true
    );
    var system                  = createObject("java", "java.lang.System");
    variables.test_phone_number = system.getenv("DIALPAD_TEST_PHONE_NUMBER");
    variables.test_user_id      = system.getenv("DIALPAD_TEST_USER_ID");
    variables.test_webhook_url  = system.getenv("DIALPAD_TEST_WEBHOOK_URL");
    variables.test_webhook_id   = system.getenv("DIALPAD_TEST_WEBHOOK_ID");
  }

  function afterAll() {
  }


  /*********************************** BDD SUITES ***********************************/

  function run() {
    describe("Dialpad CFC", function() {
      beforeEach(() => {
      });

      afterEach(() => {
      });

      it("requests company information", function() {
        var result = variables.dialpad.getCompany();
        expect(isValidResponseStructure(result)).toBeTrue();
        var response = deserializeJSON(result.raw.response);
        expect(response.method).toBe("GET");
        expect(response.route).toBe("/company");
      });

      describe("manages Call Centers", function() {
        it("requests a list of call centers", function() {
          var result = variables.dialpad.listCallCenters();
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("GET");
          expect(response.route).toBe("/callcenters");
        });
      });

      describe("manages Offices", function() {
        it("requests a list of offices", function() {
          var result = variables.dialpad.listOffices();
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("GET");
          expect(response.route).toBe("/offices");
        });
      });

      describe("sends SMS", function() {
        it("requests SMS be sent on behalf of a user", function() {
          var sending_user_id = variables.test_user_id;
          var text            = "This is a test from DialpadCFC";
          var recipient       = [variables.test_phone_number];
          var result          = variables.dialpad.sendSMS(user_id = sending_user_id, to_numbers = recipient, text = text);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("POST");
          expect(response.route).toBe("/sms");
          expect(response.body).toHaveKey("text");
          expect(response.body.text).toBe(text);
          expect(response.body).toHaveKey("to_numbers");
          expect(response.body.to_numbers).toBe(recipient);
          expect(response.body).toHaveKey("user_id");
          expect(response.body.user_id).toBe(sending_user_id);
        });
      });

      describe("manages Subscriptions", function() {
        it("requests that a call event subscription be created", function() {
          var result = variables.dialpad.createCallEventSubscription(webhook_id = variables.test_webhook_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("POST");
          expect(response.route).toBe("/subscriptions/call");
          expect(response.body).toHaveKey("webhook_id");
          expect(response.body.webhook_id).toBe(variables.test_webhook_id);
        });
        it("requests a call event subscription be deleted", function() {
          var subscription_id = 1;
          var result          = variables.dialpad.deleteCallEventSubscription(subscription_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("DELETE");
          expect(response.route).toBe("/subscriptions/call/#subscription_id#");
        });
        it("requests a list of call event subscriptions", function() {
          var result = variables.dialpad.listCallEventSubscriptions();
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("GET");
          expect(response.route).toBe("/subscriptions/call");
        });
        it("requests that an SMS event subscription be created", function() {
          var result = variables.dialpad.createSMSEventSubscription(webhook_id = variables.test_webhook_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("POST");
          expect(response.route).toBe("/subscriptions/sms");
          expect(response.body).toHaveKey("webhook_id");
          expect(response.body.webhook_id).toBe(variables.test_webhook_id);
        });
        it("requests an SMS event subscription be deleted", function() {
          var subscription_id = 1;
          var result          = variables.dialpad.deleteSMSEventSubscription(subscription_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("DELETE");
          expect(response.route).toBe("/subscriptions/sms/#subscription_id#");
        });
        it("requests a list of SMS event subscriptions", function() {
          var result = variables.dialpad.listSMSEventSubscriptions();
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("GET");
          expect(response.route).toBe("/subscriptions/sms");
        });
      });

      describe("manage Users", function() {
        it("requests a list of users", function() {
          var result = variables.dialpad.listUsers();
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("GET");
          expect(response.route).toBe("/users");
        });
      });

      describe("manages Webhooks", function() {
        it("requests that a webhook be created", function() {
          var secret = "test_secret";
          var result = variables.dialpad.createWebhook(hook_url = variables.test_webhook_url, secret = secret);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("POST");
          expect(response.route).toBe("/webhooks");
          expect(response.body).toHaveKey("hook_url");
          expect(response.body.hook_url).toBe(variables.test_webhook_url);
          expect(response.body).toHaveKey("secret");
          expect(response.body.secret).toBe(secret);
        });
        it("requests a list of webhooks", function() {
          var result = variables.dialpad.listWebhooks();
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("GET");
          expect(response.route).toBe("/webhooks");
        });
        it("requests a webhook be deleted", function() {
          var webhook_id = 1;
          var result     = variables.dialpad.deleteWebhook(webhook_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          var response = deserializeJSON(result.raw.response);
          expect(response.method).toBe("DELETE");
          expect(response.route).toBe("/webhooks/#webhook_id#");
        });
        it("can decode webhooks", function() {
          var webhookBody = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.UC-Hj59_0b7KRPDqlh9zSO4TdXx0CMUE7TIHy9jng8c";
          var result      = variables.dialpad.decodeWebhook(webhookBody);
          debug(result);
        });
      });
    });
  }

  function isValidResponseStructure(required any response) {
    if( !isStruct(arguments.response) ){
      return false;
    }
    if( !arguments.response.keyExists("raw") ){
      return false;
    }
    if( !isStruct(arguments.response.raw) ){
      return false;
    }
    if( !arguments.response.raw.keyExists("response") ){
      return false;
    }
    if( !isJSON(arguments.response.raw.response) ){
      return false;
    }
    var payload = deserializeJSON(arguments.response.raw.response);
    if( !payload.keyExists("method") ){
      return false;
    }
    if( !payload.keyExists("route") ){
      return false;
    }
    if( !payload.keyExists("params") ){
      return false;
    }
    if( !payload.keyExists("body") ){
      return false;
    }
    if( len(payload.body) && !isStruct(payload.body) ){
      return false;
    }
    return true;
  }

}
