# Overview
This is the flutter setup script, with the main porpuse of creating the full scaffolding of the flutter app

# Introduction
From the Setup there a large number of new files added that are more basically for other specific projects like SOLOMON and other this files includes AGENTS.md, CLAUYDE.md, widgets, skills, and commands.

As the setup has to work in global that any project can use it, aim we need to ensure the skills , commands,  the widgets and system prompts works very fine to any project, update anything we have to get the global components for the components very dependent should be ignored (deleted)


# Requirements
You as the Senior mobile engineer you are required to assist me to create a full working script for the project setup, the scripty shouuld allow.
The script should allow scaffolding, the full project and setup as according to the standards. 

The script should ensure the installing and use of `ipf_flutter_starter_pack` and not `flutterpack` as the directory for the `ipf_flutter_starter_pack` is at the path `/Users/danfordchris/projects/iPF_Flutter_Starter_Pack.` ensure the proper generation of the skills as from the package level it handles that

Ensure the initial setup of the colorschema for the theming so as the generated components(widgets) should **NEVER** use the manualy defined colors. Also ensure the the available packages as in `ipf_flutter_starter_pack` which need configuration in the project level should handle that as for example

```bash
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
    }

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

```

Also ensure all other requires setup that the package level requires is well settled with the `manifest` and `info.plist` some of default permission like network should be set

Ensure all configuration as for specific state management is well set from the setup level


Ensure never use the git keep method as it has been used


# Deliverables

When user run the script the user should be asked several questions but with default answers (currently i placed them in blackets the expected defaults)
```text
Whats the name of the app ____ (flutter_app_<index>)
What the expected package_name ____ (com.<flutter-app>.app)
Whats your Expected state management tool ____(provider)
Would you need the app signing both debug and release _____ (false)
<Add other necessary questions that feels write and necessary>

```

The script should return the output as the way user expects, with the Modified the AGENTS.md and CLAUDE.md to have instructions for the specific project, with all skills commands and widgets should be for the project level

Feel free to understand the naming patterns used in `/Users/danfordchris/projects/ipf_apps/solomon-stockbrokers-app` and use them the same as for example api calling `ApiManager` and more

**ALWAYS** Ensure no room for errors or mistakes

**ALWAYS** Always never create sometj=hing that only works, but as mobile engineer create somthing that is production ready with well engineered to be used by anyone or any agent without breaking the production code

**ALWAYS** Never assumme things whatever is being conduction should be sure. If Need clarification feel free to understand

**ALWAYS** Understand what is needed before executing anything, feel free to ask questions
