component extends="testbox.system.BaseSpec" {

  /*********************************** LIFE CYCLE Methods ***********************************/

  function beforeAll() {
    variables.dialpad           = new dialpad(includeRaw = true);
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
    describe("LIVE Dialpad CFC requests", function() {
      beforeEach(() => {
      });

      afterEach(() => {
      });

      xit("can get company information", function() {
        var result = variables.dialpad.getCompany();
        expect(isValidResponseStructure(result)).toBeTrue();
        expect(result.data).toHaveKey("id");
        expect(result.data.id).toBeNumeric();
      });

      describe("manage Call Centers", function() {
        xit("can list call centers", function() {
          var result = variables.dialpad.listCallCenters();
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("items");
          expect(result.data.items).toBeArray();
          expect(result.data.items).notToBeEmpty();
          expect(result.data.items[1]).toHaveKey("id");
          expect(result.data.items[1].id).toBeNumeric();
        });
      });

      describe("manage Offices", function() {
        xit("can list offices", function() {
          var result = variables.dialpad.listOffices();
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("items");
          expect(result.data.items).toBeArray();
          expect(result.data.items).notToBeEmpty();
          expect(result.data.items[1]).toHaveKey("id");
          expect(result.data.items[1].id).toBeNumeric();
        });
      });

      describe("send SMS", function() {
        xit("can send on behalf of a user", function() {
          var sending_user_id = variables.test_user_id;
          var text            = "This is a test from DialpadCFC";
          var recipient       = [variables.test_phone_number];
          var result          = variables.dialpad.sendSMS(user_id = sending_user_id, to_numbers = recipient, text = text);
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("to_numbers");
          expect(result.data.to_numbers).toBeArray();
          expect(result.data.to_numbers).notToBeEmpty();
          expect(result.data.to_numbers).toBe(recipient);
          expect(result.data).toHaveKey("direction");
          expect(result.data.direction).toBe("outbound");
        });
      });

      describe("manage Subscriptions", function() {
        xit("can create a call event subscription", function() {
          var result = variables.dialpad.createCallEventSubscription(webhook_id = variables.test_webhook_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("id");
        });
        xit("can list call event subscriptions", function() {
          var result = variables.dialpad.listCallEventSubscriptions();
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data.items).toBeArray();
          expect(result.data.items).notToBeEmpty();
          expect(result.data.items[1]).toHaveKey("id");
          expect(result.data.items[1].id).toBeNumeric();
        });
        xit("can create an SMS event subscription", function() {
          var result = variables.dialpad.createSMSEventSubscription(webhook_id = variables.test_webhook_id);
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("id");
        });
        xit("can list SMS event subscriptions", function() {
          var result = variables.dialpad.listSMSEventSubscriptions();
          debug(result);
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data.items).toBeArray();
          expect(result.data.items).notToBeEmpty();
          expect(result.data.items[1]).toHaveKey("id");
          expect(result.data.items[1].id).toBeNumeric();
        });
      });

      describe("manage Users", function() {
        xit("can list users", function() {
          var result = variables.dialpad.listUsers();
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("items");
          expect(result.data.items).toBeArray();
          expect(result.data.items).notToBeEmpty();
          expect(result.data.items[1]).toHaveKey("id");
          expect(result.data.items[1].id).toBeNumeric();
        });
      });

      describe("manage Webhooks", function() {
        xit("can create a webhook", function() {
          var secret = "test_secret";
          var result = variables.dialpad.createWebhook(hook_url = variables.test_webhook_url, secret = secret);
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("hook_url");
          expect(result.data.hook_url).toBe(variables.test_webhook_url);
          expect(result.data).toHaveKey("id");
          expect(result.data).toHaveKey("signature");
          expect(result.data.signature).toHaveKey("secret");
          expect(result.data.signature.secret).toBe(secret);
        });
        xit("can list webhooks", function() {
          var result = variables.dialpad.listWebhooks();
          expect(isValidResponseStructure(result)).toBeTrue();
          expect(result.data).toHaveKey("items");
          expect(result.data.items).toBeArray();
          expect(result.data.items).notToBeEmpty();
          expect(result.data.items[1]).toHaveKey("id");
          expect(result.data.items[1].id).toBeNumeric();
        });
      });
    });
  }

  function isValidResponseStructure(required any response) {
    if( !isStruct(arguments.response) ){
      return false;
    }
    if( !arguments.response.keyExists("statusCode") ){
      return false;
    }
    if( arguments.response.statusCode != 200 ){
      return false;
    }
    if( !isStruct(arguments.response.data) ){
      return false;
    }
    return true;
  }

}
