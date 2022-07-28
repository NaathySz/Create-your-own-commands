#include <sourcemod>
#include <sdktools>
#include <multicolors>

ArrayList gArray_LoadCommands;

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0"

public Plugin myinfo = 
{
	name = "Create commands easily",
	author = "Nathy",
	description = "Create unlimited commands very easy",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/nathyzinhaa"
}

public void OnPluginStart()
{
	AddCommandListener(SayHook, "say");
	AddCommandListener(SayHook, "say_team");
	LoadCommands();
}

void LoadCommands()
{
	gArray_LoadCommands = new ArrayList(64);
	
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "configs/customcommands.cfg");
	
	File hFile = OpenFile(sPath, "r");
	
	char sLineContent[512];
	
	if (hFile != INVALID_HANDLE)
	{
		while (hFile.ReadLine(sLineContent, sizeof(sLineContent)))
			gArray_LoadCommands.PushString(sLineContent);
		
		delete hFile;
	}
}

public Action SayHook(int client, const char[] command, int args)  
{
    char arg[256];
    GetCmdArgString(arg, sizeof(arg));
    StripQuotes(arg);
    TrimString(arg);
    if(arg[0] == '!')
    checkccmds(client, arg);
    
    return Plugin_Continue;
}

public void checkccmds(int client, const char[] args)
{
	for (int i = 0; i < gArray_LoadCommands.Length; i++)
    {
        char data[128];
        gArray_LoadCommands.GetString(i, data, sizeof(data));
        
        char sBuffer[2][64];
        ExplodeString(data, "|", sBuffer, 2, 64);
        if(StrContains(args, sBuffer[0], false) != -1)
        {
            CPrintToChat(client, "%s", sBuffer[1]);
            return;
        }
    }
}