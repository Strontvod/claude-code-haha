[Skip to content](https://github.com/enricoros/big-AGI/issues/291#start-of-content)

You signed in with another tab or window. [Reload](https://github.com/enricoros/big-AGI/issues/291) to refresh your session.You signed out in another tab or window. [Reload](https://github.com/enricoros/big-AGI/issues/291) to refresh your session.You switched accounts on another tab or window. [Reload](https://github.com/enricoros/big-AGI/issues/291) to refresh your session.Dismiss alert

{{ message }}

[enricoros](https://github.com/enricoros)/ **[big-AGI](https://github.com/enricoros/big-AGI)** Public

- [Sponsor](https://github.com/sponsors/enricoros)
- [Notifications](https://github.com/login?return_to=%2Fenricoros%2Fbig-AGI) You must be signed in to change notification settings
- [Fork\\
1.6k](https://github.com/login?return_to=%2Fenricoros%2Fbig-AGI)
- [Star\\
6.9k](https://github.com/login?return_to=%2Fenricoros%2Fbig-AGI)


# Openrouter.ai rate limit for free tiers\#291

[New issue](https://github.com/login?return_to=https://github.com/enricoros/big-AGI/issues/291)

Copy link

[New issue](https://github.com/login?return_to=https://github.com/enricoros/big-AGI/issues/291)

Copy link

Closed

Closed

[Openrouter.ai rate limit for free tiers](https://github.com/enricoros/big-AGI/issues/291#top)#291

Copy link

Labels

[type: bugSomething isn't working](https://github.com/enricoros/big-AGI/issues?q=state%3Aopen%20label%3A%22type%3A%20bug%22) Something isn't working

Milestone

[1.9.0](https://github.com/enricoros/big-AGI/milestone/9)

[![@shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=80)](https://github.com/shiribailem)

## Description

[![@shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=48)](https://github.com/shiribailem)

[shiribailem](https://github.com/shiribailem)

opened [on Dec 21, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#issue-2053364157)

Issue body actions

Openrouter's free tiers are limited to 1 request every 5 seconds. When using ReAct it becomes hit or miss on a free model whether it'll hit the rate limit.

It would be really helpful if this could be implemented internally to automatically delay requests on those models. And for future flexibility this could just be a setting on a model (in case rate limits change or another service implements a rate limit that didn't before).

The most minimal effort version of this would be setting a "delay 5 seconds before sending request on these models", but obviously that's not ideal. The ideal would be an internal timestamp of the last request sent and just adding a wait until that timestamp is 5s old.

## Activity

[![enricoros](https://avatars.githubusercontent.com/u/32999?u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4&size=80)](https://github.com/enricoros)

### enricoros commented on Dec 22, 2023on Dec 22, 2023

[![@enricoros](https://avatars.githubusercontent.com/u/32999?u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4&size=48)](https://github.com/enricoros)

[enricoros](https://github.com/enricoros)

[on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#issuecomment-1867291547)

Owner

More actions

Good to know, I think I can deal with this.

How do I determine whether to turn on the rate limiter? (E.g. how do I know if one is Ina free tier?)

[![shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=80)](https://github.com/shiribailem)

### shiribailem commented on Dec 22, 2023on Dec 22, 2023

[![@shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=48)](https://github.com/shiribailem)

[shiribailem](https://github.com/shiribailem)

[on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#issuecomment-1867324247)

Author

More actions

it's actually by model rather than tier, at least in the case of openrouter. In the list of models all the ones that are free have that limit (and you can't pay to lift it)

[![shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=80)](https://github.com/shiribailem)

### shiribailem commented on Dec 22, 2023on Dec 22, 2023

[![@shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=48)](https://github.com/shiribailem)

[shiribailem](https://github.com/shiribailem)

[on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#issuecomment-1867325690)

Author

More actions

ftr, the "free tier" in openrouter is just that they'll give you $1 of credit before demanding a card (and charging you that balance)

[![](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)enricoros](https://github.com/enricoros)

added

[type: bugSomething isn't working](https://github.com/enricoros/big-AGI/issues?q=state%3Aopen%20label%3A%22type%3A%20bug%22) Something isn't working

[on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#event-11325784514)

[![](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)enricoros](https://github.com/enricoros)

added this to [big-AGI build-in-public roadmap](https://github.com/users/enricoros/projects/4) [on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#event-14879098821)

[![](https://avatars.githubusercontent.com/in/235829?s=64&v=4)github-project-automation](https://github.com/apps/github-project-automation)

moved this to Requests in [big-AGI build-in-public roadmap](https://github.com/users/enricoros/projects/4) [on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291)

[![](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)enricoros](https://github.com/enricoros)

added this to the [1.9.0](https://github.com/enricoros/big-AGI/milestone/9) milestone [on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#event-11325789128)

[![](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)enricoros](https://github.com/enricoros)

closed this as [completed](https://github.com/enricoros/big-AGI/issues?q=is%3Aissue%20state%3Aclosed%20archived%3Afalse%20reason%3Acompleted) in [5d1620b](https://github.com/enricoros/big-AGI/commit/5d1620b5c108c7632aa624ce65370787b0d74975) [on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#event-11325791031)

[![](https://avatars.githubusercontent.com/in/235829?s=64&v=4)github-project-automation](https://github.com/apps/github-project-automation)

moved this from Requests to Ready in [big-AGI build-in-public roadmap](https://github.com/users/enricoros/projects/4) [on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291)

[![enricoros](https://avatars.githubusercontent.com/u/32999?u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4&size=80)](https://github.com/enricoros)

### enricoros commented on Dec 22, 2023on Dec 22, 2023

[![@enricoros](https://avatars.githubusercontent.com/u/32999?u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4&size=48)](https://github.com/enricoros)

[enricoros](https://github.com/enricoros)

[on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#issuecomment-1867590134) · edited by [enricoros](https://github.com/enricoros)

Edits

Owner

More actions

@tmajibon thanks for reporting this. This has been deployed on the main branch, and also on [https://get.big-agi.com](https://get.big-agi.com/) .

With the occasion, OpenRouter has been improved, and models have knowledge of free vs non-free. Thanks!

[![shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=80)](https://github.com/shiribailem)

### shiribailem commented on Dec 22, 2023on Dec 22, 2023

[![@shiribailem](https://avatars.githubusercontent.com/u/5880760?u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4&size=48)](https://github.com/shiribailem)

[shiribailem](https://github.com/shiribailem)

[on Dec 22, 2023on Dec 22, 2023](https://github.com/enricoros/big-AGI/issues/291#issuecomment-1867713139)

Author

More actions

Thanks! It looks to be working great, I haven't run into any rate limit errors now on those models.

🚀React with 🚀1enricoros

[![](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)enricoros](https://github.com/enricoros)

mentioned this [on Dec 28, 2023on Dec 28, 2023](https://github.com/enricoros/big-AGI/issues/291#event-1343147864)

- [Release 1.9.0 #310](https://github.com/enricoros/big-AGI/issues/310)


[![](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)enricoros](https://github.com/enricoros)

removed this from [big-AGI build-in-public roadmap](https://github.com/users/enricoros/projects/4) [on Dec 28, 2023on Dec 28, 2023](https://github.com/enricoros/big-AGI/issues/291)

[![](https://avatars.githubusercontent.com/u/93469969?s=64&u=fe88c3274bff07fac2cb24eb89b70597a12c39c9&v=4)disappointmentinc](https://github.com/disappointmentinc)

added a commit that references this issue [on Jan 28, 2024on Jan 28, 2024](https://github.com/enricoros/big-AGI/issues/291#event-11619644418)

[OpenRouter: limit free model calls to 1/5s. Closes #291](https://github.com/disappointmentinc/nextjs-tlb-gpt4/commit/5d1620b5c108c7632aa624ce65370787b0d74975)

[OpenRouter: limit free model calls to 1/5s. Closes #291](https://github.com/disappointmentinc/nextjs-tlb-gpt4/commit/5d1620b5c108c7632aa624ce65370787b0d74975)

[OpenRouter: limit free model calls to 1/5s. Closes](https://github.com/disappointmentinc/nextjs-tlb-gpt4/commit/5d1620b5c108c7632aa624ce65370787b0d74975) [enricoros#291](https://github.com/enricoros/big-AGI/issues/291)

This issue will close once commit 5d1620b is merged into the 'main' branch. [5d1620b](https://github.com/disappointmentinc/nextjs-tlb-gpt4/commit/5d1620b5c108c7632aa624ce65370787b0d74975)

[Sign up for free](https://github.com/signup?return_to=https://github.com/enricoros/big-AGI/issues/291)**to join this conversation on GitHub.** Already have an account? [Sign in to comment](https://github.com/login?return_to=https://github.com/enricoros/big-AGI/issues/291)

## Metadata

## Metadata

### Assignees

No one assigned

### Labels

[type: bugSomething isn't working](https://github.com/enricoros/big-AGI/issues?q=state%3Aopen%20label%3A%22type%3A%20bug%22) Something isn't working

### Projects

No projects

### Milestone

- [1.9.0\\
Closed on Dec 28, 2023Dec 28, 2023, 100% complete](https://github.com/enricoros/big-AGI/milestone/9)

### Relationships

None yet

### Development

Code with agent mode

Select code repository

No branches or pull requests

### Participants

[![@enricoros](https://avatars.githubusercontent.com/u/32999?s=64&u=a1321c15b67f0f7de57813ba20be8562e8ffd67b&v=4)](https://github.com/enricoros)[![@shiribailem](https://avatars.githubusercontent.com/u/5880760?s=64&u=8b9b83a1c42f62c9e648be59bfc73714d5122250&v=4)](https://github.com/shiribailem)

## Issue actions

You can’t perform that action at this time.