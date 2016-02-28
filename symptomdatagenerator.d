import std.json;
import std.stdio;
import std.file;
import std.string;
import std.random;
import std.conv;



bool isIn(string[] array, string str)
{
    foreach( int i, string check; array)
    {
        if (check == str)
        {   return true;    }
    }
    return false;
}


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

    string[] symptomsList;
    lineCount = 0;
    while(!symptoms.eof())
    {
        string line = strip (symptoms.readln());
        symptomsList ~= line;
        lineCount++;
    }

    string[] ReportMethodsList;
    lineCount = 0;
    while(!ReportMethods.eof())
    {
        string line = strip (ReportMethods.readln());
        ReportMethodsList ~= line;
        lineCount++;
    }

    string[] LocationPairsList;
    lineCount = 0;
    while(!LocationPairs.eof())
    {
        string line = strip (LocationPairs.readln());
        LocationPairsList ~= line;
        lineCount++;
    }

    writefln("The asymptoms list is %s long", symptomsList.length);

    writeln(symptomsList);


    //How many symptoms does each patiant have maximum?
    int RealSymptomLim = 4;
    int  OtherSymptomLim = 4;

    int RealSymptomStart = realstart;
    int OtherSymptomStart = realend+1; //HOW MANY REAL ANTHRAX SYMPTOMS HAVE WE GOT?
    //WHAT ABOUT THE DIFFERENT KINDS OF ANTHRAX?????
    //XXX

    char[4] types = ['@','%','$','*'];


    int i = 0;
    while (!ids.eof())  //For every ID
    {
        if (i >= patiants.length)   //Check because EOF doesnt happen until i is already out of range
        { break; }

        patiants[i] = parseJSON(JSONStructureString); //New patiant
        patiants[i].object["patiant_id"] = JSONValue(ids.readln());
        patiants[i].object["report_method"] = JSONValue(ReportMethodsList[uniform(0,ReportMethodsList.length)]);   //Get random report method
        patiants[i].object["report_latitude"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length)]);   //Get random report method
        patiants[i].object["report_longitude"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length)]);   //Get random report method

        writeln(patiants[i].object["report_method"].toString());

        string RealSymptoms[];
        RealSymptoms.length = RealSymptomLim;

        int noRealSimps = uniform(0, RealSymptomLim);
        int noFakeSimps = uniform(1, OtherSymptomLim);

        writeln("real symps:");
        writeln(noFakeSimps);
        writeln("fake symps:");
        writeln(noFakeSimps);

        char type = types[uniform (0, types.length)]; //pick a type of anthrax for this patiant
        string[] choosenSymptomsList;       //The symptoms we've got already, no duplicates!
        string[] choosenFakeSymptomsList;

        writefln("Choose: %s", type);

        string symptom;

        for (int k = 0; k < noRealSimps; k++)   //Get real symptoms 0 to max. Will sometimes pick 0
        {
            //make sure that the symptom we pick, conforms with the type we picked earlier.
            symptom = "";
            while (indexOf(symptom,type) == -1)     //While the first char is not one of the type chars
            {
                symptom = symptomsList[uniform(0,RealSymptomLim)];

                if (isIn(choosenSymptomsList, symptom))
                {   symptom = " ";  }
                else
                {   break;  }

            }
            writeln("choosen!", chompPrefix(symptom, to!string(type)));
            patiants[i]["Symptoms"].array ~= JSONValue(chompPrefix(symptom, to!string(type)));       //Pick a few real symptoms.
            choosenSymptomsList ~= symptom;
        }

        string FakeSymptoms[];
        FakeSymptoms.length = symptomsList.length;
        for (int f = 0; f < noFakeSimps; f++)   //Get real symptoms 0 to max. Will sometimes pick 0
        {
            writeln("Other symptomstart: ",OtherSymptomStart);
            symptom = symptomsList[uniform(OtherSymptomStart,symptomsList.length)];
            while (isIn(choosenFakeSymptomsList, symptom))
            {
                symptom = symptomsList[uniform(OtherSymptomStart,symptomsList.length)];
            }
            writeln("choosen!", chompPrefix(symptom, to!string(type)));
            patiants[i]["Symptoms"].array ~= JSONValue(chompPrefix(symptom, to!string(type)));       //Pick a few real symptoms.
            choosenFakeSymptomsList ~= symptom;

        }

        i++;
    }


    foreach(int p, JSONValue patiant; patiants)
    {
        string patiantJSON = patiant.toString();
        append("Patiants.json", patiantJSON);
        writeln(patiantJSON);

    }

        






}
