Making additional accounts or API keys will not affect your rate limits, as we
govern capacity globally. We do however have different rate limits for
different models, so you can share the load that way if you do run into
issues.

## Rate Limits and Credits Remaining

To check the rate limit or credits left on an API key, make a GET request to `https://openrouter.ai/api/v1/key`.

TypeScript SDKPythonTypeScript (Raw API)

```
import { OpenRouter } from '@openrouter/sdk';

const openRouter = new OpenRouter({
  apiKey: '<OPENROUTER_API_KEY>',
});

const keyInfo = await openRouter.apiKeys.getCurrent();
console.log(keyInfo);
```

If you submit a valid API key, you should get a response of the form:

TypeScript

```
type Key = {
  data: {
    label: string;
    limit: number | null; // Credit limit for the key, or null if unlimited
    limit_reset: string | null; // Type of limit reset for the key, or null if never resets
    limit_remaining: number | null; // Remaining credits for the key, or null if unlimited
    include_byok_in_limit: boolean;  // Whether to include external BYOK usage in the credit limit

    usage: number; // Number of credits used (all time)
    usage_daily: number; // Number of credits used (current UTC day)
    usage_weekly: number; // ... (current UTC week, starting Monday)
    usage_monthly: number; // ... (current UTC month)

    byok_usage: number; // Same for external BYOK usage
    byok_usage_daily: number;
    byok_usage_weekly: number;
    byok_usage_monthly: number;

    is_free_tier: boolean; // Whether the user has paid for credits before
    // rate_limit: { ... } // A deprecated object in the response, safe to ignore
  };
};
```

There are a few rate limits that apply to certain types of requests, regardless of account status:

1. Free usage limits: If you’re using a free model variant (with an ID ending in `:free`), you can make up to 20 requests per minute. The following per-day limits apply:

- If you have purchased less than 10 credits, you’re limited to 50 `:free` model requests per day.

- If you purchase at least 10 credits, your daily limit is increased to 1000 `:free` model requests per day.


2. **DDoS protection**: Cloudflare’s DDoS protection will block requests that dramatically exceed reasonable usage.

If your account has a negative credit balance, you may see `402` errors, including for free models. Adding credits to put your balance above zero allows you to use those models again.

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`