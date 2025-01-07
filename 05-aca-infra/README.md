# aca-infra

This stage can run locally and on github actions. 

If on github actions: Need to add github GH_TOKEN as Repository secret

Apim api is not created as part of terraform

After ```api``` is deployed via github workflow:
 - Manually import it into apim using OpenAPI specification. Backend api must be public for it to be imported by apim. As we are using fastapi, openapi spec is available at ```$Application_Url/openapi.json```. API URL suffix is important, let's give it a value of api. Choose the product created as part of terraform
 - Manually update the ```aca_web.yaml``` workflow with ```REACT_APP_APIM_URL```. Append it with API URL suffix which is set as api

Update inbound policy of api to allow cors and to allow apim to authenticate with backend api:

```
<inbound>
        <cors allow-credentials="true"> 
            <allowed-origins> 
                <origin>the origin url of web app</origin> 
            </allowed-origins> 
            <allowed-methods preflight-result-max-age="300"> 
                <method>*</method> 
            </allowed-methods> 
            <allowed-headers> 
                <header>*</header> 
            </allowed-headers> 
            <expose-headers> 
            <header>*</header> 
            </expose-headers> 
        </cors>
        <authentication-managed-identity resource="b147569f-643a-4d3b-b0e4-55750750f770" client-id="e880ad99-c842-49ee-9d71-5f51e40c8a08" output-token-variable-name="msi-access-token" ignore-error="false"/>
            <set-header name="Authorization" exists-action="override">
                <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
            </set-header> 
</inbound>
```

b147569f-643a-4d3b-b0e4-55750750f770 = client_id of backend api azure ad app

e880ad99-c842-49ee-9d71-5f51e40c8a08 = client_id of apim uai 