import std.json;
import std.stdio;
import std.file;
import std.string;
import std.random;
import std.conv;


void main(string[] args)
{


    //Open a file containing ilst of patiant IDs (else use for loop iterator)
    //Open file with Anthrax Symptoms
    //Open file with other symptoms
    //define json structure

    //Loop for how ever many patiants we asked for


    File JSON;
    File ids;
    File symptoms;
    File ReportMethods;
    File LocationPairs;


    int realstart = 0;
    int realend = 0;
    int fakeend = 0;
    int fakestart = 0;



    if (args.length >= 11)       //Open the files
    {
        JSON = File(args[1], "r");
        ids = File(args[2], "r");
        symptoms = File(args[3], "r");
        realstart = to!int(args[4]);
        realend = to!int(args[5]);
        fakestart =  to!int(args[6]);
        fakeend =  to!int(args[7]);
        ReportMethods =  File(args[8], "r");
        LocationPairs = File(args[9], "r");

    }
    else if (args.length == 2)
    {
        if (args[1] == "help")
        {
            writeln( "JSONFile idsfile symptomsfile [startOfRealSymptoms] [EndOfRealSymptoms] [StartOfFakeSymptoms] [EndOfFakeSymptoms] reportmethods locationpairs [numberOfPatiants]");
            return;
        }

    }
    else
    {
        return ;
    }

    string JSONStructureString = "{    \"patiant_id\": \"\", \"report_method\":\"\", \"report_latitude\": \"\",\"report_longitude\": \"\",\"Symptoms\":[] }";       //Read in the JSON structure from file
    string JSONStructureFields[10];

    int lineCount = 1;

    while (!JSON.eof())
    {
        JSONStructureFields[lineCount] = JSON.readln();
    }



    //JSONValue j = parseJSON(JSONStructureString);     //Parse the JSON
    JSONValue j = parseJSON(JSONStructureString);
    writefln("Doing %s Patiants", args[]);

    writeln("Using JSON structure: \n");
    writeln(j.toString);

    JSONValue patiants[];    //List of patiants

    patiants.length = to!int(args[10]);


    //Read in all the anthrax symptoms


    //XXX For now we have statically defined limits to how many symptoms there are - We could make this dynamic


    //TODO Put all this inside a function - Its horrible out here!

    string symptomsList[];
    symptomsList.length = 20;
    lineCount = 0;
    while(!symptoms.eof())
    {
        string line = strip (symptoms.readln());
        symptomsList[lineCount] = line;
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

    writefln("The asymptoms list is %s long", symptomsList.length);

    writeln(symptomsList);


    //How many symptoms does each patiant have maximum?
    int RealSymptomLim = 4;
    int  OtherSymptomLim = 2;

    int RealSymptomStart = realstart;
    int OtherSymptomStart = realend; //HOW MANY REAL ANTHRAX SYMPTOMS HAVE WE GOT?
    //WHAT ABOUT THE DIFFERENT KINDS OF ANTHRAX?????
    //XXX


    int i = 0;
    writeln(patiants.length);
    while (!ids.eof())  //For every ID
    {
        if (i >= patiants.length)   //Check because EOF doesnt happen until i is already out of range
        { break; }

        writeln(i);
        patiants[i] = parseJSON(JSONStructureString); //New patiant
        patiants[i].object["patiant_id"] = JSONValue(ids.readln());
        patiants[i].object["report_method"] = JSONValue(ReportMethodsList[uniform(0,ReportMethodsList.length)]);   //Get random report method
        patiants[i].object["report_latitude"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length)]);   //Get random report method
        patiants[i].object["report_longitude"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length)]);   //Get random report method

    writeln("Hi");

        string RealSymptoms[];
        RealSymptoms.length = RealSymptomLim;


        int noRealSimps = uniform(0, RealSymptomLim);
        int noFakeSimps = uniform(0, OtherSymptomLim);
    writeln("Hi");

        for (int k = 0; k < noRealSimps;k++)   //Get real symptoms 0 to max. Will sometimes pick 0
        {
            patiants[i]["Symptoms"].array ~= JSONValue(symptomsList[uniform(0,symptomsList.length)]);       //Pick a few real symptoms.
        }

        string FakeSymptoms[];
        FakeSymptoms.length = symptomsList.length;
        for (int k = 0; k < noFakeSimps;k++)
        {
            patiants[i]["Symptoms"].array ~= JSONValue(symptomsList[uniform(0,symptomsList.length)]);       //Pick a few real symptoms.
        }
    writeln("Hi");

        i++;
    }


    foreach(int p, JSONValue patiant; patiants)
    {
        append("Patiants.json", patiant.toString());
    }

        






}
