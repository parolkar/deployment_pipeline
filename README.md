Deployment Pipeline  (Let's make Continuous Deployment painless)
-------------------

In the life of Deployment Manager of an agile aggressive team<sup>1</sup>, there comes a day when he/she needs to manage releases and communicate with
stake holders about features being released and also control what goes live on production. Why control? because in any practical scenario, feature which is ready
and accepted by product managers doesn't guarantee its readiness for the business and marketing and quite often non-technical teams need a buffer time before
a feature is released.  Deployment Pipeline is here to help you manage these releases and keep non-technical teams and users better informed about whats going on.


### Ideal Scenario:

 1. Your Product Managers write feature/bug stories and prioritize them anytime during the day.
 2. Your engineering team believes in Continuous Integration and all engineers commit to  Master branch (or Trunk) several times a day.
 3. If the build (CI) is green, that tag from Master Branch might get pushed to QA environment for stories to be delivered.
 4. Once all stories are accepted, (QA) Staging Tag is deployed to production, Happy Ending of the day!

### Practical Scenario:
 1. You have 5 Product Managers who request feature/bug stories and prioritize them anytime during the day.
 2. You have 10 engineers working on 5 stories and commits to  Master branch (or Trunk) several times a day.
 3. Build is green only 70% of time during the day.
 4. By the time build is green there are commits to 4 finished & intermediate commits to an 1 un-finished story.
 5. QA delivers the stories(4) which has been finished and 3 are accepted and 1 is rejected.
 6. Among 3 accepted stories Marketing Team takes a call to hold 1 story even though its ready.
 7. Now we have 2 production ready, 1 held by marketing, 1 rejected, 1 un-finished.
 8. Commits related to 2 prod ready are shuffled between commits related to all non-ready stories.
 9. Among 2 ready-to-deploy , 1 is marked urgent but it's commits are part of the day when CI build was RED (not necessarily due to this commit).
 10. What and how would you deploy today?  (cherry-pick commits for a feature with no green build? FAIL) You post-pone release!
  - ==Day Rolls Over==
 11. 3 new stories requested by Product Managers.
 12. An engineer finishes 2 of new stories quickly whose commits goes to master. 3rd new story might take long to finish, but gets its commits pushed to master.
 13. Build is green and a tag on master is pushed to QA environment.
 14. 2 new stories are delivered and accepted.
 15. ...
 16. Which staging tag on master would you deploy to production? At any given time there are commits from un-finished/un-delivered stories.


### Solutions:
 1. Sure you can use [feature toggle](http://martinfowler.com/bliki/FeatureToggle.html), but it only makes sense for long running (for weeks) set of stories. When every story starts to have a feature toggle, then system gets polluted with
  if-else everywhere, which again is difficult to manage and error prone
 2. You can also ask engineers to have separate feature branches for each stories and rebase with master often. This brings in its own [over heads](http://martinfowler.com/bliki/FeatureBranch.html)...
  * Time spent in merging changes
  * It needs a single controller of release branch who pulls the changes and makes sure what goes live is vetted. (This controller can soon become a bottleneck in the process)
  * Engineers work in isolation and can not commit intermediate commits unless feature is complete.
 3. Use All-Accepted Marker : This is a commit on master below which all stories have been accepted and there are few commits (shuffled with other un-finished) above the marker that can be cleanly cherry-picked.


#### Workflow for All-Accepted Marker Deployment:
  1. Find a suitable commit below which all stories are accepted
  2. Branch out to new "Release" Branch
  3. Inform stake-holders about what features are being released and locked down release marker
  4. Cherry-pick related commits from above the marker to release branch
  5. Build the release branch and wait for it to be green
  6. Deploy release branch to production
  7. Automate this entire process


#### Chasing a commit for release:
  1. You make a choice for commit in mainline, all the stories below that will be deployed. (but the stories are not yet accepted or in progress)
  2. Inform everybody in your dev/prod mgmt team that following stories should be accepted before we release
  3. Branch out to new "Release" Branch
  4. In case, few stories are rejected or new bugs are discovered ask everyone to fix it on release branch and also backport (merge) those changes to mainline.
  5. Once all stories are accepted, build the release branch and wait for it to be green
  6. Deploy release branch to production
  7. Automate this entire process

### Deployment Pipeline @ Work :
####Getting Started:
<pre><code>
developers-machine:~/workspace/repository (master)$ <b>pipeline help</b>
Tasks:
  pipeline help [TASK]       # Describe available tasks or one specific task
  pipeline release_plan      # Prepares a release plan
  pipeline setup             # Setup Deployment Pipeline Tool
  pipeline status            # lists all stories with their status
  pipeline suitable_release  # Suggests a release commit to be picked and also includes a release plan

Options:
  [--config=CONFIG]  # A ruby file that defines relevant constants & configs. accepts ENV $PIPELINE_CONFIG
                     # Default: /Users/dev_home/.pipeline_config
</code></pre>


####Find Suitable Commit for All-Accepted Marker:
<pre><code>
developers-machine:~/workspace/repository (master)$ <b>pipeline suitable_release --last-release-commit="c0512b2cebf86e96baa1fe783ba4c01b55b40000"</b>
  Analysing... c0512b2cebf86e96baa1fe783ba4c01b55b40000
  Commit is untagged hence considered
  Analysing... aaa756c1c79829aa6680df66dda62f0a59c336a1
  Stories accepted for aaa756c1c79829aa6680df66dda62f0a59c336a1, hence considered
  Analysing... 7b9cf2863e35add6663a7e964440b4f75befe572
  Stories accepted for 7b9cf2863e35add6663a7e964440b4f75befe572, hence considered
  Analysing... eb94f53ac8969fee134fe6677f7a6bf457b155c5
  Stories accepted for eb94f53ac8969fee134fe6677f7a6bf457b155c5, hence considered
  Analysing... 44d1324d0899cba238a3a53d470f655fcf4b64e2
  Stories accepted for 44d1324d0899cba238a3a53d470f655fcf4b64e2, hence considered
  Analysing... ef9d1a6a1e8bac5112c6ff491c97c083769bd553
  Stories accepted for ef9d1a6a1e8bac5112c6ff491c97c083769bd553, hence considered
  Analysing... ee0112cad3f58b362281c786a197d27148b13f12
  Stories accepted for ee0112cad3f58b362281c786a197d27148b13f12, hence considered
  Analysing... 331cdaca1cfd3672d901ca56218cef9330540241
  Commit is untagged hence considered
  Analysing... a2380cf7f3ad3ab660927bac6177073b123b002e
  Commit is untagged hence considered
  Analysing... b1c281030100d40f46057b5b8463ee7d16952b29
  Commit is untagged hence considered
  Analysing... e65d84b68ff038a96769bd9b10c1cb3997f625bb
  Commit is untagged hence considered
  Analysing... 20c4a74ffd298f0d9bf60679b23823fc32d4ec26
  Unsuitable commit because story status is not accepted
  <b>Commit that can be pickup up for release is: e65d84b68ff038a96769bd9b10c1cb3997f625bb</b>

</code></pre>

####Find status of stories between given commits on a branch:

<pre><code>
developers-machine:~/workspace/repository (master)$ <b>pipeline status --commit-range="3191320e8d7c5a402d17a560b12677b44344b300..9471d8794a28cc3a6888fa3a42c03edb4f4458812" --html </b>
Fetching...:   100% |============================================| Time:   0:00:11
STATUS:
</code></pre>
<quote>
>OUTPUT:
> finished:
>
  * (bug) [Users unable to reset their password](http://www.pivotaltracker.com/story/show/1)  requested by **Rajnikanth** owned by Tom Cruise
  * (bug) [Banner ad spacing issue](http://www.pivotaltracker.com/story/show/2)  requested by **Bill G** owned by Jacky Chan

>accepted:
>
  * (chore) [Reduce memory foot print](http://www.pivotaltracker.com/story/show/3)  requested by **Big B** owned by Tony
  * (feature) [Users can foresee their future](http://www.pivotaltracker.com/story/show/4)  requested by **Rajnikanth** owned by Tom Cruise

> Following commits have not been tagged, (**why?**)
>
  * 3191320e8d7c5a402d17a560b12677b44d11b3d1  Super crazy commit by **Tom**
  * 49297c0b1e28cc63d0117c62b08420a4465b6b8f  lazy to add tag by **Dick**
  * 401a997f402666a148a8e54582b6feedfb7a9148  Fixed Build  by **Harry**
</quote>


####Find suitable release plan (find out exact stuff that will be seen on production):

<pre><code>
developers-machine:~/workspace/repository (master)$ <b>pipeline release_plan  --last-release-commit="3191320e8d7c5a402g17a561b12777b44344b3d5" --target-release-commit="9471d8794a28cc3a6888fa3a42c03eab4f445823" --html </b>
Fetching...:   100% |============================================| Time:   0:00:22

</code></pre>
<quote>
>OUTPUT:
> Release can be locked at commit 9471d8794a28cc3a6888fa3a42c03edb4f4458a6

> Stories being released are:
>
  * (chore) [Reduce memory foot print](http://www.pivotaltracker.com/story/show/3)  requested by **Big B** owned by Tony
  * (feature) [Users can foresee their future](http://www.pivotaltracker.com/story/show/4)  requested by requested by **Rajnikanth** owned by Tom Cruise


> Commits that needs to be cherry-picked as they are part of above stories:
>
  * 401a997f402666a148a8e54582b6feedfb7a9149  [#1234] Related to memory  by **Harry**

</quote>


####Installation:
<pre><code>
  developers-machine:~/workspace/repository (master)$ <b>gem install deployment_pipeline</b>
  developers-machine:~/workspace/repository (master)$ <b>pipeline setup</b>
  Let's setup Deployment Pipeline
  Pivotal Tracker Token:  <i>2d2b1f708d2b1f708cd2b1f708c</i>
  Pivotal Tracker Project Ids (comma separated):  <i>1234,5678,9876</i>
  Setup complete! (Configuration updated in <b>~/.pipeline_config</b>)
  Thanks for choosing Deployment Pipeline

</code></pre>


####Gotchas:
 * [BUG] Segmentation fault (ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin11.4.0]): If you see random segmentation faults, install the rugged gem provided in the extra folder.


####Inspiration

 * [Continuous Delivery](http://en.wikipedia.org/wiki/Continuous_delivery)
 * [Git Story](https://github.com/visibletrap/git_story) Project from [visibletrap](https://github.com/visibletrap) & [acroca](https://github.com/acroca)
 * [Jenkin's](http://jenkins-ci.org/) Build Pipeline Project

####Thanks to the awesome team @ [Viki](http://viki.com) for letting me contribute to this project

<sub>\[**1**\]: Team which is motivated for [release-often philosophy](http://radar.oreilly.com/2009/03/continuous-deployment-5-eas.html) so much that it releases to production multiple times a day. It uses DVCS like **[Git](http://git-scm.com)** and agile story tracker like **[PIVOTAL TRACKER](http://www.pivotaltracker.com)**. It has adopted TDD & **[Continious Integration](http://en.wikipedia.org/wiki/Continuous_integration)** as way of life. Every engineer [commits to master all the time](http://martinfowler.com/bliki/FeatureBranch.html#PromiscuousIntegrationVsContinuousIntegration).
</sub>

---------------------------------------------------------------
<font size='1'>
Copyright (c) 2012 Abhishek Parolkar [abhishek[at]parolkar[dot]com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</font>