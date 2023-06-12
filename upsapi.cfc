/*
File: upsapi.cfc

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
*/

/*
upsapi.cfc 0.1
Author: Robert Davis; kabutotx@gmail.com
*/

component displayName="upsapi" hint="Base component for UPS API" {
  public upsapi function init(
	  boolean developmentServer="false") {

    if ( arguments.developmentServer ) {
      variables.baseUrl = "wwwcie.ups.com";
    } else {
      variables.baseUrl = "onlinetools.ups.com";
    }
    return ( this );
  }

  public struct function getAccessToken(
          string id = "", string secret = "") {
    
    credentials = ToBase64(arguments.id & ":" & arguments.secret);
    httpService = new http(method = "POST", charset = "utf-8", url = "https://#variables.baseUrl#/security/v1/oauth/token");
    httpService.addParam(name = "Content-Type", type = "header", value = "application/x-www-form-urlencoded");
    httpService.addParam(name = "x-merchant-i", type = "header", value = "string");
    httpService.addParam(name = "Authorization", type = "header", value = "Basic " & credentials);
    httpService.addParam(type = "body", value = "grant_type=client_credentials");
    result = httpService.send().getPrefix();
    return stcResponse = deserializeJSON(result.filecontent);
  }

  public struct function rating(
          required string token,
          required struct rateParameters,
          required struct request ) {
    
    cfparam(name="rateParameters.version", default="v1");
    cfparam(name="rateParameters.requestoption", default="rate");
    cfparam(name="rateParameters.transID", default="");
    cfparam(name="rateParameters.transactionSrc", default="testing");
    buildurl = "https://#variables.baseUrl#/api/rating/#arguments.rateParameters.version#/#arguments.rateParameters.requestoption#";
    httpService = new http(method = "POST", charset = "utf-8", url = buildurl );
    httpService.addParam(name = "Content-Type", type = "header", value = "application/json");
    httpService.addParam(name = "transId", type = "header", value = "#arguments.rateParameters.transID#");
    httpService.addParam(name = "transactionSrc", type = "header", value = "#arguments.rateParameters.transactionSrc#");
    httpService.addParam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
    httpService.addParam(type = "body", value = serializeJSON(arguments.request));
    result = httpService.send().getPrefix();
    return stcResponse = deserializeJSON(result.filecontent);
  }
}