---
title: "My journey in the Kubernetes Release Team: Part 1"
date: 2020-09-10T08:58:41+05:30
description: "My learnings from working on the Kubernetes Release Team and leading the enhancements vertical"
tags: ["kubernetes", "open-source", "community"]
favorite: true
---

During this period last year, I got interested in how a new Kubernetes version is released and what goes on behind it. After some searching, I found that all of the process and the roles are well documented in the [Release Team Role Handbooks][rt-handbooks].

![rt-handbooks-repo][rt-handbooks-repo]

I read through all of them to understand the process, why there are so many roles and what responsibilities each team is entrusted with. All of that sounded pretty interesting to me. All the teams did an amazing work and were equally crucial for the well functioning of a Kubernetes Release cycle. I got specifically interested with the Enhancements and CI Signal teams. I started to dig how can I lend my hand to the efforts.

## Shadow Roles

With the role handbooks, I got to know of the [Release Team Shadow Program][shadow] which is aimed at mentoring new contributors and training them to be the next leads of the Kubernetes Release Team. The shadows are expected to learn from the leads and fill in wherever necessary. You can think of these positions as "trainee/intern" roles at your workplace. This was just a primer on the program. You can read more on the link.

> Okay. I know where to start with. **But how?**

Turns out it requires a **marginal amount of effort**, **bucket loads of curiosity** and **time commitment** to apply for the Shadow Program. The Release Team at the start of every release cycle pushes out a public form for inviting applications to the shadow roles.

{{< tweet 1174811618984620032 >}}

## Taking the plunge

I took the initiative and filled the form with my interests and thoughts. And few days later I, along with other shadows, was welcomed by [MrBobbyTables][bob] to my first involvement with the Release Team. :tada:

![1.17 Introduction](/images/rt/1.17-intro.png)

The next few months were just like a roller coaster ride. The team that I was shadowing for was the Enhancements Team and our work was to shepherd features for the Kubernetes release and maintain the status of [Kubernetes Enhancements Proposals][k/enhancements], aka, KEP(s).

The role involved understanding each outstanding KEP, pinging respective OWNERS if the enhancement would be graduating in the current release cycle, and keeping track whether the enhancements are satisfying the requirements for the release.


<!-- **Here were a few takeaways that I took while working on the team:** -->
### Here were a few takeaways that I took while working on the team:

- Knowledge of what is involved when adding a feature into Kubernetes!!!
- Reading through an enourmous amount of KEPs, I got to know about the features themselves
- Communicating effectively with others and breaking the ice
- A lot of GitHub triage skills and tricks
- Tricks of wrangling data on a spreadsheet :wink:

> I will write about the complete lifecycle of a Kubernetes Enhancement Proposal in a future article.

We released `Kubernetes 1.17 : The Chillest Release` (Yes! That is the release theme :smiley:) after all the efforts of the [1.17 release team][1.17-team]. The last release of the year is usually the most chilled out and is a bit short due to the December vacation.

{{< tweet 1204410714380742656 >}}

The whole team became akin to a family for me spending all that effort into ensuring a smooth release. We, the Enhancements Team ([Bob][bob], [Jeremy][jeremy], [Anna][anna], [Kristin][kristin]), even got together at KubeCon San Diego to meet up physically.

![1.17-rt-meet](/images/rt/1.17-rt-meet.jpg)

## The Next Steps

After Kubernetes 1.17, I signed up again for the Kubernetes 1.18 team for Enhancements to get more exposure to the KEP landscape. This time [Jeremy](https://twitter.com/jrrickard) was leading the Enhancements Team. It was fun again to work with the enhancements team ([Jeremy][jeremy], [Kirsten][kirsten], [Heba][heba], [John][john]), all the same just this time there were new shadows along with me compared to last time.

This release cycle was mostly the same for me other than I was a bit more involved than the last time having served on the team previously. And, after all the hard work of the [1.18 release team][1.18-team], we were treated to a **quarky** Kubernetes 1.18 :star:.

{{< tweet 1242924529636106240 >}}


## Graduating to be the Enhancements Lead :rocket:

Aaaaaand after a splendid 1.18, [Jeremy][jeremy] nominated me to be the Enhancements Lead for Kubernetes 1.19 Release Team. I was stoked to get the opportunity and at the same time scared if I can do full justice to the responsibility bestowed upon me. The knowledge of the role while working with [Bob][bob] and [Jeremy][jeremy] in the previous release teams gave me the confidence that I can fulfill the responsibilities of the role.

[![1.19 Nomination](/images/rt/1.19-nomination.png)](https://github.com/kubernetes/sig-release/issues/1031)

This release cycle eventually became special in many ways. We were hit by a deadly pandemic which changed a lot of things in our life. The release cycle was extended to 5 months instead of the usual 12 weeks cadence. The pandemic and various other factors shaved off quite a bit of the usual bandwidth the community had previously. These times were very crucial for the whole world and the team didn't want to put undue additional pressure on the amazing contributors that we have.

The shadows that I selected for the Enhancements Team spanned 12 and a half hours of timezone and created an amazing round the earth coverage for the team. This meant no team member had to toil in their odd times of the day. I take this opportunity to **thank again all the enhancements shadows - [Kirsten][kirsten], [Harsha][harsha], [Miroslaw][miroslaw] and [John][john] for their efforts even in such hard times**.

After those tense & tough 5 months firefighting a lot of issues, the [1.19 release team][1.19-team] released `Kubernetes 1.19: Accentuate the Paw-sitive`. You can read about the release on the [Kubernetes Blog][1.19-blog] and the upcoming [Kubernetes 1.19 Release Webinar][1.19-webinar] where I will be presenting along with the 1.19 Release Lead [Taylor][taylor] and the 1.19 Communications Lead [Max][max].

{{< tweet 1298704500648054784 >}}

With that, my watch ended over the Release Enhancements Team and it was time to hand over the baton to next lead. :peace:

I was very happy to nominate [Kirsten][kirsten] to succeed me as the next Enhancements Lead of the Release Team. :tada:

[![1.20 Nomination](/images/rt/1.20-nomination.png)](https://github.com/kubernetes/sig-release/issues/1185)

Along with that it was time for me to graduate to my next role. I look forward to working with [Jeremy][jeremy], [Savitha][savitha] and [Daniel][daniel] for Kubernetes 1.20. I will be shadowing the Release Lead for Kubernetes 1.20. :sunglasses:

[![1.20 Onboarding](/images/rt/1.20-onboarding.png)](https://github.com/kubernetes/sig-release/issues/1201)


## How can you get involved? :raised_hands:

The last release of the year, Kubernetes 1.20, is going to be published in December. The Release Team is looking out for folks for the shadow roles. All you need to do is go ahead, read the [role handbooks][rt-handbooks], figure out which role interests you the best and then fill the [form][rt-1.20-form]. We ask every prospect to fill the form because we want to know if the release team would be a good fit for you and to find the right role for you in the Release Team.

The applications will be open until _End of Day Friday, September 11, 2020 Pacific Time_.

{{< tweet 1300478913961889792 >}}


## Still in doubt? :mag:

I would say just go ahead and volunteer for the shadow roles. :ship:

Feel free to contact me on Twitter at [@theonlynabarun](https://twitter.com/theonlynabarun), or on the [Kubernetes Slack](https://slack.k8s.io), in case you have anything to ask.


## Quick References

- [The selection process][rt-selection]
- [Shadow overview][shadow]
- [Role Handbooks][rt-handbooks]

---

### Update since the original version

I wrote this article over 6 months back and since then led the [Kubernetes 1.21 Release Team][1.21-team]. I plan to write about my experience leading the Release Team in the near future. Do subscribe to the [RSS feed][rss] for updates.

[k/enhancements]: https://github.com/kubernetes/enhancements
[rt-handbooks]: https://github.com/kubernetes/sig-release/tree/master/release-team/role-handbooks
[rt-handbooks-repo]: /images/rt/rt-handbooks.png
[rt-shadow]: https://github.com/kubernetes/sig-release/blob/master/release-team/shadows.md
[rt-1.20-form]: https://forms.gle/58jyAeewYGJNbsVZA
[1.19-webinar]: https://www.cncf.io/webinars/kubernetes-1-19/
[bob]: https://twitter.com/MrBobbyTables
[jeremy]: https://twitter.com/jrrickard
[kirsten]: https://github.com/kikisdeliveryservice
[harsha]: https://twitter.com/NeerDoseMonster
[miroslaw]: https://github.com/msedzins
[john]: https://twitter.com/johnbelamaric
[daniel]: https://twitter.com/hasheddan
[savitha]: https://twitter.com/coffeeartgirl
[taylor]: https://twitter.com/onlydole
[max]: https://twitter.com/mkoerbi
[1.19-blog]: https://kubernetes.io/blog/2020/08/26/kubernetes-release-1.19-accentuate-the-paw-sitive/
[1.17-team]:https://github.com/kubernetes/sig-release/blob/master/releases/release-1.17/release_team.md
[1.18-team]:https://github.com/kubernetes/sig-release/blob/master/releases/release-1.18/release_team.md
[1.19-team]: https://github.com/kubernetes/sig-release/blob/master/releases/release-1.19/release_team.md
[1.21-team]: https://github.com/kubernetes/sig-release/blob/master/releases/release-1.21/release-team.md
[shadow]: https://github.com/kubernetes/sig-release/blob/master/release-team/shadows.md
[anna]: https://twitter.com/antheajung
[kristin]: https://twitter.com/KristinCMartin
[heba]: https://twitter.com/helayoty
[rt-selection]: https://github.com/kubernetes/sig-release/blob/master/release-team/release-team-selection.md
[rss]: /index.xml
