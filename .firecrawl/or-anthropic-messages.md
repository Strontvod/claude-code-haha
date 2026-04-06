Creates a message using the Anthropic Messages API format. Supports text, images, PDFs, tools, and extended thinking.

### Authentication

AuthorizationBearer

API key as bearer token in Authorization header

### Request

This endpoint expects an object.

modelstringRequired

messageslist of objects or nullRequired

Show 2 properties

max\_tokensintegerOptional

systemstring or list of objectsOptional

Show 2 variants

metadataobjectOptional

Show 1 properties

stop\_sequenceslist of stringsOptional

temperaturedoubleOptional

top\_pdoubleOptional

top\_kintegerOptional

toolslist of objectsOptional

Show 7 variants

tool\_choiceobjectOptional

Show 4 variants

thinkingobjectOptional

Show 3 variants

service\_tierenumOptional

Allowed values:autostandard\_only

output\_configobjectOptional

Configuration for controlling output behavior. Supports the effort parameter and structured output format.

Show 2 properties

cache\_controlobjectOptional

Show 2 properties

streambooleanOptional

context\_managementobject or nullOptional

Show 1 properties

providerobject or nullOptional

When multiple model providers are available, optionally indicate your routing preference.

Show 13 properties

pluginslist of objectsOptional

Plugins you want to enable for this request, including their settings.

Show 6 variants

userstringOptional`<=256 characters`

A unique identifier representing your end-user, which helps distinguish between different users of your app. This allows your app to identify specific users in case of abuse reports, preventing your entire app from being affected by the actions of individual users. Maximum of 256 characters.

session\_idstringOptional`<=256 characters`

A unique identifier for grouping related requests (e.g., a conversation or agent workflow) for observability. If provided in both the request body and the x-session-id header, the body value takes precedence. Maximum of 256 characters.

traceobjectOptional

Metadata for observability and tracing. Known keys (trace\_id, trace\_name, span\_name, generation\_name, parent\_span\_id) have special handling. Additional keys are passed through as custom metadata to configured broadcast destinations.

Show 5 properties

modelslist of stringsOptional

speedenumOptional

Controls output generation speed. When set to `fast`, uses a higher-speed inference configuration at premium pricing. Defaults to `standard` when omitted.

Allowed values:faststandard

### Response

Successful response

containerobject or null

Show 2 properties

contentlist of objects

Show 13 variants

idstring

modelstring

roleenum

Allowed values:assistant

stop\_reasonenum or null

Show 7 enum values

stop\_sequencestring or null

typeenum

Allowed values:message

providerenum

Show 104 enum values

usageobject

Show 13 properties

### Errors

400

Bad Request Error

401

Unauthorized Error

403

Forbidden Error

404

Not Found Error

429

Too Many Requests Error

500

Internal Server Error

503

Service Unavailable Error

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`