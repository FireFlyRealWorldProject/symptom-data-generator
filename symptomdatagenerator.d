import std.json;
import std.stdio;
import std.file;
import std.string;


void main(string[] args)
{


    //Open a file containing ilst of patiant IDs (else use for loop iterator)
    //Open file with Anthrax Symptoms
    //Open file with other symptoms
    //define json structure

    //Loop for how ever many patiants we asked for


    File JSON;
    File ids;
    File Asymptoms;
    File Osymptoms;

    if (args.length >= 6)       //Open the files
    {
        JSON = File(args[1], "r");
        ids = File(args[2], "r");
        Asymptoms = File(args[3], "r");
        Osymptoms= File(args[4], "r");
    }
    else
    {
        return ;
    }





    string JSONStructureString = strip(JSON.readln());       //Read in the JSON structure from file
    string JSONStructureFields[10];

    int lineCount = 1;

    while (!JSON.eof())
    {
        JSONStructureFields[lineCount] = JSON.readln();
    }


    writeln("Using JSON structure: \n");
    writeln(JSONStructureString);

    JSONValue j = parseJSON(JSONStructureString);     //Parse the JSON

    writefln("Doing %s Patiants", args[5]);

    JSONValue patiants[];    //List of patiants


    //Read in all the anthrax symptoms


    //XXX For now we have statically defined limits to how many symptoms there are - We could make this dynamic

    string AsymptomsList[];
    AsymptomsList.length = 20;
    lineCount = 0;
    while(!Asymptoms.eof())
    {
        string line = strip (Asymptoms.readln());
        AsymptomsList[lineCount] = line;
        lineCount++;
    }

    string OsymptomsList[];
    OsymptomsList.length = 20;
    lineCount = 0;
    while(!Osymptoms.eof())
    {
        string line = strip (Osymptoms.readln());
        OsymptomsList[lineCount] = line;
        lineCount++;
    }

    writefln("The asymptoms list is %s long", AsymptomsList.length);
    writefln("The osymptoms list is %s long", OsymptomsList.length);

    writeln(AsymptomsList);
    writeln(OsymptomsList);

    while (!ids.eof())  //For every ID
    {
        patiants[i] = parseJSON(JSONStructureString); //New patiant
        for (int i = 0; i < 10; i++)
        {
            patiants[i].object[JSONStructureFields[i]] = JSONValue(ids.readln());

        }

    }
        






}
