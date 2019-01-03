# Contributing to Windows Microsoft Learn Modules

## Quick start

If you're already familiar with the process of contributing to docs.microsoft.com, there are just a few unique aspects to note which I will outline below. If you're entirely new to the process, there are more general steps to help you get started below. 

### Repo location and folder structure

The Learn Windows private repo is located here: https://github.com/MicrosoftDocs/learn-windows-pr

We have decided to use the ["fy19q2" branch](https://github.com/MicrosoftDocs/learn-windows-pr/tree/fy19q2/) for authoring, then merging this branch to "master" only when we reach milemarkers and see that the build is successful. 

The repo contains lots of config files, but your authoring should really only need to take place in the "includes" folder of the module you are working on: [*learn-windows-pr/learn-windows-pr/windows/name-of-your-module/includes/*](https://github.com/MicrosoftDocs/learn-windows-pr/tree/fy19q2/learn-windows-pr/windows/Introduction/includes)

### Two ways to author and make changes: web browser or local editor

You can either author directly in the github web browser by just selecting the module where you would like to author [here](https://github.com/MicrosoftDocs/learn-windows-pr/tree/fy19q2/learn-windows-pr/windows), navigating to the unit file where you would like to author in the "includes" folder, and clicking the pencil icon ✎. If you don't already have the repo forked, github will automatically create a fork on your account. (The url will be https://github.com/your_Github_User_Name/learn-windows-pr). 

Make your changes and select the "Preview changes" tab for a sneak-peek at how your markdown will render, but understand that it won't have the frills offered by the docs platform until it is committed and builds to the [review.docs.microsoft.com](https://review.docs.microsoft.com/en-us/learn-windows/windows/keepinguptodate/2-keeping-your-tools-up-to-date?branch=fy19q2) site. To save your changes, enter a note about what you changed, then select "Propose file change". This will open a pull request window -- be sure that base fork is "MicrosoftDocs/learn-windows-pr" and that the base is "fy19q2".   

If you already have some familiarity with Git commands, rather than using the web browser, you can make changes to files locally with the editing software of your choice (VS Code is our recommendation) and benefit from spellcheck, etc. 

Follow these steps:
1) Fork the Learn-Windows-PR repo so that there is a copy on your GitHub account (there is a "fork" button at the top right of the repo web page), 
2) If you don't already have git installed on your machine, go to [https://git-scm.com/download/win](https://git-scm.com/download/win). The git installation will ask several questions... Do you want to run this? > Yes, Select Components? > Just check all of the boxes, Default editor? > I recommend selecting VS Code, Path environment? > Select "Use Git and optional Unix tools form Windows Command Prompt", Choosing HTTPS transport? > USe the native Windows Secure Channel, Configure line ending? > "Checkout Windows-style", Configure the terminal emulator? > select "Use Windows default console", Configuring extras? > select them all except "Enable symbolic links", Configuring experimental? > Don't check these... now select "Install"!  

Once git is installed, clone your fork of the repo to your local machine: `git clone https://github.com/your_GitHub_User_Name/learn-windows-pr.git`

Open the repo folder (from whichever folder you cloned it to on your machine) with the editor of your choice (VS Code), make your changes, `git add`, `git commit`, `git push origin master` (or whatever branch youre working in). You should receive an email letting you know if your changes built without errors or you can check using the OPS tool here: https://ops.microsoft.com/#/sites/Docs/docsets/learn-windows-pr?tabName=builds

#### Authoring in the includes folder with markdown

Files inside the "includes" folder are authored in Markdig-flavor markdown. If you've never authored with markdown, here is a [basic guide](https://review.docs.microsoft.com/en-us/help/contribute/media/documents/markdown-cheatsheet.pdf) and for more advanced docs platform specifics, check this [Markdown Reference for OPS](https://review.docs.microsoft.com/en-us/help/contribute/markdown-reference?branch=master) guide (how to insert notes, tips, tables, videos, code snippets, relative links, bookmarks, anchors, code tables, selectors, etc).

### Help?!

If you get stuck or break something, don't panic. Most everything is reversible with some Git magic. (Famous last words?) If you have any questions specific to this Learn Windows repo, email [Matt Woj](mailto:mattwoj@microsoft.com). If he's not available or there is a crisis, submit a request in the [APEX Site Help Portal](https://sitehelp.microsoft.com/), or post a message on the [Docs Support Teams Channel](https://teams.microsoft.com/l/team/19%3a7ecffca1166a4a3986fed528cf0870ee%40thread.skype/conversations?groupId=de9ddba4-2574-4830-87ed-41668c07a1ca&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47) or the [Microsoft Learn Teams Channel](https://teams.microsoft.com/l/team/19%3ae71b47303a114990a3f0748661f48929%40thread.skype/conversations?groupId=2cd70980-6c76-45e6-8b88-02ea0b1fd561&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47) if it's specific to the Learn platform.

Find updates, files, and conversation specific to this Learn Windows content in our [Microsoft Learn for Windows Teams Channel](https://teams.microsoft.com/l/team/19%3ab0c1b8781ef540fe9a220938f2e1b1f1%40thread.skype/conversations?groupId=06f9cdc1-0cb2-4c50-a232-6d4fe2940bd9&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47).

## Brand new to docs contribution?

If you don't already have one, you'll need to [create a GitHub account](https://github.com/join).

>[!NOTE]
>If you're a Microsoft employee, link your GitHub account to your Microsoft alias on the [Microsoft Open Source portal](https://repos.opensource.microsoft.com/). Join the **"Microsoft"** and **"MicrosoftDocs"** organizations).

When setting up your GitHub account, we also recommend these security precautions:
- Create a [strong password for your Github account](https://github.com/settings/admin).
- Enable [two-factor authentication](https://github.com/settings/two_factor_authentication/configure).
- Save your [recovery codes](https://github.com/settings/auth/recovery-codes) in a safe place.
- Update your [public profile settings](https://github.com/settings/profile).
   - Set your name, and consider setting your *Public email* to *Don't show my email address*.
   - We recommend you upload a profile picture, as a thumbnail will be shown on docs pages to which you contribute.
- If you plan to use a command line workflow, consider setting up [Git Credential Manager for Windows](https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/latest) so that you don't have to enter your password each time you make a contribution.

Taking these steps is important as the publishing system is tied to GitHub and you'll be listed as either author or contributor to each article using your GitHub alias.

## Additional links for writing tips and guidance

- [Writing principles checklist](https://review.docs.microsoft.com/en-us/help/contribute/writing-principles-checklist?branch=master)
- [Every day words list](https://review.docs.microsoft.com/en-us/help/contribute/writing-principles-everyday-words?branch=master)
- [Writing principles: Quick reference](https://review.docs.microsoft.com/en-us/help/contribute/writing-principles-voice-job-aid?branch=master)
- [Creating a Microsoft Learn Module](https://review.docs.microsoft.com/en-us/learn-docs/docs/create-a-module?branch=master)
- [Common "Gotchas" with Markdown authoring](https://review.docs.microsoft.com/en-us/help/contribute/contribute-how-to-write-use-markdown?branch=master#gotchas-and-troubleshooting)
- [Accessibility guidance](https://review.docs.microsoft.com/en-us/help/contribute/contribute-accessibility-guidelines?branch=master)
- [Text formatting tips](https://review.docs.microsoft.com/en-us/help/contribute/text-formatting-guidelines?branch=master)
- [Writing Alt Text for images](https://review.docs.microsoft.com/en-us/help/contribute/contribute-alt-text?branch=master)

## Microsoft Open Source Code of Conduct
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
