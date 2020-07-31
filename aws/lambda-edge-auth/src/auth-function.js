"use strict";
exports.handler = (event, context, callback) => {
  // Get request and request headers
  const request = event.Records[0].cf.request;

  // Configure authentication
  const authUser = process.env.authUser;
  const authPass = process.env.authPass;

  // Construct the Basic Auth string
  const authString =
    "Basic " + new Buffer(authUser + ":" + authPass).toString("base64");

  // Require Basic authentication
  const headers = request.headers;
  if (
    typeof headers.authorization == "undefined" ||
    headers.authorization[0].value !== authString
  ) {
    const body = "Unauthorized";
    const response = {
      status: "401",
      statusDescription: "Unauthorized",
      body: body,
      headers: {
        "www-authenticate": [{ key: "WWW-Authenticate", value: "Basic" }],
      },
    };
    callback(null, response);
  }

  // Continue request processing if authentication passed
  callback(null, request);
};
