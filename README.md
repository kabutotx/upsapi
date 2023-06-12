# ColdFusion Authorize.net API CFC

This is a ColdFusion CFC used to connect to UPS API using OAuth.

## API's Supported:
 * Rate
 

## Requirements
* ACF 10+
* Lucee 5+

To authenticate with the UPS API, use your application's OAuth ID and SECRET. If you don't have these credentials, setup your application from https://developer.ups.com.

## Initialization

This will init the cfc and setup testing or production URL.

**CreateObject()**

	variables.upsapi = CreateObject('component', 'upsapi').init(developmentServer=true);

**New Keyword**

	variables.upsapi = New upsapi(developmentServer=true);

## Sample Usage

See upstest.cfm.

Steps:
	1. Retrieve site token. This is not a user specific token requiring them to login to UPS.
	(Store token and expiration somewhere you can retrieve such as a DB. Sample just uses a cookie. You can the use same key until expiration where you will need to get a new token)
	2. Create 2 structures. First is the request parameters. Second is the structure using case specific keys for the request JSON. See API documentation for key names.
	3. Call api passing token, parameter structure, and request structure.

## Response

Result for API will be structure from the deserialized JSON.

## License

    Copyright © Robert Davis

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
