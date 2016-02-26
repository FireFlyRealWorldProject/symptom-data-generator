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
    writeln("Using JSON structure: \n");
    writeln(JSONStructureString);


    JSONValue j = parseJSON(JSONStructureString);     //Parse the JSON

    writeln("Doing %i Patiants", args[5]);


    JSONValue patiants[];    //List of patiants


    for (int i = 0; i < 10; i++)
    {
    }
        






}
