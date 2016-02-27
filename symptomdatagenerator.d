import std.json;
import std.stdio;
import std.file;
import std.string;
import std.random;


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
    File ReportMethods;
    File LocationPairs;

    if (args.length >= 8)       //Open the files
    {
        JSON = File(args[1], "r");
        ids = File(args[2], "r");
        Asymptoms = File(args[3], "r");
        Osymptoms= File(args[4], "r");
        ReportMethods =  File(args[5], "r");
        LocationPairs = File(args[6], "r");
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


    //TODO Put all this inside a function - Its horrible out here!

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

    string ReportMethodsList[];
    ReportMethodsList.length = 20;
    lineCount = 0;
    while(!ReportMethods.eof())
    {
        string line = strip (ReportMethods.readln());
        ReportMethodsList[lineCount] = line;
        lineCount++;
    }

    string LocationPairsList[];
    LocationPairsList.length = 20;
    lineCount = 0;
    while(!LocationPairs.eof())
    {
        string line = strip (LocationPairs.readln());
        LocationPairsList[lineCount] = line;
        lineCount++;
    }

    writefln("The asymptoms list is %s long", AsymptomsList.length);
    writefln("The osymptoms list is %s long", OsymptomsList.length);

    writeln(AsymptomsList);
    writeln(OsymptomsList);


    //How many symptoms does each patiant have maximum?
    int RealSymptomLim = 4;
    int  OtherSymptomLim = 2;

    int RealSymptomStart = 0;
    int OtherSymptomStart = 10; //HOW MANY REAL ANTHRAX SYMPTOMS HAVE WE GOT?
    //WHAT ABOUT THE DIFFERENT KINDS OF ANTHRAX?????
    //XXX


    int i = 0;
    while (!ids.eof())  //For every ID
    {
        patiants[i] = parseJSON(JSONStructureString); //New patiant
        patiants[i].object["patiant_id"] = JSONValue(ids.readln());
        patiants[i].object["report_method"] = JSONValue(ReportMethodsList[uniform(0,ReportMethodsList.length)]);   //Get random report method
        patiants[i].object["report_latitude"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length)]);   //Get random report method
        patiants[i].object["report_longitude"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length)]);   //Get random report method

//        patiants[i].object["Symptoms"] = JSONValue([]);   //Get random report method

        string RealSymptoms[];
        RealSymptoms.length = RealSymptomLim;
        for (int k = 0; i < uniform(RealSymptomStart, RealSymptomLim);i++)
        {
            patiants[i]["Symptoms"].array ~= JSONValue(AsymptomsList[uniform(0,AsymptomsList.length)]);       //Pick a few real symptoms.
        }

        string OtherSymptoms[];
        OtherSymptoms.length = OtherSymptomLim;
        for (int k = 0; i < uniform(OtherSymptomStart, OtherSymptomLim);i++)
        {
            patiants[i]["Symptoms"].array ~= JSONValue(OsymptomsList[uniform(0,OsymptomsList.length)]);       //Pick a few other symptoms.
        }

        i++;
    }
        






}
