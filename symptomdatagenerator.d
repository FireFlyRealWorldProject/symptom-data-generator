import std.json;
import std.stdio;
import std.file;
import std.string;
import std.random;
import std.conv;
import std.format;



bool isIn(string check, string str)
{
    writeln("checking if is in:");

    writeln(check);
    writeln(str);

    if (check == str)
    {   return true;    }

    return false;
}


string pickSymptom(string sympList[],string type, int end, int start)  //Pick a symptom from the list
{

    string symptom = "";

    if (type == "")
    {
        symptom = sympList[uniform(start,end)];   //If we're doing non-typed symptoms
        return symptom;
    }


    symptom = sympList[uniform(0,end)];
    while (indexOf(symptom,type) < 0)     //While the first char is not one of the type chars
    {
        symptom = sympList[uniform(0,end)];

    }

    return symptom;

}

bool checkChoosen(string choosenList[], string symptom) //Check if the picked symptom is already been picked
{
    bool isIn = false;

    //XXX For some reason this gets a range violation because i is always gets to one more than it really should for some reason...
    writeln("Length");
    writeln(choosenList.length);
    if (choosenList.length <= 1)
    {   return false;   }

    foreach(int i, string choosen; choosenList)
    {
        if (choosen == symptom)
        {   isIn = true; break;  }
    }

    return isIn;


}





void main(string[] args)
{


    //Open a file containing ilst of patiant IDs (else use for loop iterator)
    //Open file with Anthrax Symptoms
    //Open file with other symptoms
    //define json structure

    //Loop for how ever many patiants we asked for


    File ids;
    File symptoms;
    File ReportMethods;
    File LocationPairs;


    int realstart = 0;
    int realend = 0;
    int fakeend = 0;
    int fakestart = 0;

    int numPatiants = 0;



    if (args.length >= 9)       //Open the files
    {
        ids = File(args[1], "r");       //This is now the patiants loaded from sample people
        symptoms = File(args[2], "r");
        realstart = to!int(args[3]);
        realend = to!int(args[4]);
        fakestart =  to!int(args[5]);
        fakeend =  to!int(args[6]);
        ReportMethods =  File(args[7], "r");
        LocationPairs = File(args[8], "r");
        numPatiants = to!int(args[9]);

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

    int lineCount = 1;



//    JSONValue j = parseJSON(JSONStructureString);
    writefln("Doing %s Patiants", args[]);

    writeln("here?");
    JSONValue patiants = parseJSON(ids.readln());    //List of patiants
    writeln("Not here!");


    writeln("READ in patiant");

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
    writeln(ReportMethodsList);

    JSONValue[] LocationPairsList;
    lineCount = 0;
    while(!LocationPairs.eof())
    {
        string line = strip (LocationPairs.readln());
        LocationPairsList ~= parseJSON(line);
        lineCount++;
    }

    writeln("read in some location pairs");

    writefln("The asymptoms list is %s long", symptomsList.length);

    writeln(symptomsList);


    //How many symptoms does each patiant have maximum?
    int RealSymptomLim = 6;
    int  OtherSymptomLim = 5;

    int RealSymptomStart = realstart;
    int OtherSymptomStart = realend+1; //HOW MANY REAL ANTHRAX SYMPTOMS HAVE WE GOT?
    //WHAT ABOUT THE DIFFERENT KINDS OF ANTHRAX?????
    //XXX

    string[2] types = ["%","$"];


    writeln("done processing shit");
    int i = 0;
    writeln(numPatiants);
    while (i < numPatiants)  //For every ID
    {
        if (i >= numPatiants)   //Check because EOF doesnt happen until i is already out of range
        { break; }

        patiants.array[i].object["report_method"] = JSONValue(strip(ReportMethodsList[uniform(0,ReportMethodsList.length-1)]));   //Get random report method
        patiants.array[i].object["report_location"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length-1)]);   //Get random report method

        writeln(patiants.array[i].object["report_method"].toString());

        string RealSymptoms[];
        RealSymptoms.length = RealSymptomLim;

        int noRealSimps = uniform(0, RealSymptomLim);
        int noFakeSimps = uniform(1, OtherSymptomLim);

        writeln("real symps:");
        writeln(noRealSimps);
        writeln("fake symps:");
        writeln(noFakeSimps);

        string type = types[uniform (0, types.length)]; //pick a type of anthrax for this patiant
        string[] choosenSymptomsList;       //The symptoms we've got already, no duplicates!
        string[] choosenFakeSymptomsList;

        writefln("Choose: %s", type);
        writeln(type);

        string symptom = "";
        bool again = false;


        //XXX TODO Add the picking of symptoms to a function, so we can call it over and over again!

        if (noRealSimps > 0)
        {
            for (int k = 0; k < noRealSimps; k++)   //Get real symptoms 0 to max. Will sometimes pick 0
            {

                //make sure that the symptom we pick, conforms with the type we picked earlier.

                symptom = pickSymptom(symptomsList,type,realend,0 );   //Pick a symptoim
                while(checkChoosen(choosenSymptomsList, symptom) == true)   //Check it isnt already picked
                {   
                    symptom = pickSymptom(symptomsList,type,realend, 0);   //If it is, pick another one and check again
                }

                //When we get here, we should have picked a symptom


                writeln("We also attempt to add to an array here");
                choosenSymptomsList ~= symptom;
                writeln("choosen list");
                writeln(choosenSymptomsList);
                string symptomObject = format("{\"name\": \"%s\"},", chompPrefix(symptom, to!string(type)));
                if (k == 0)
                {
                    patiants.array[i].object["Symptoms"] = JSONValue([parseJSON(symptomObject)]);       //Pick a few real symptoms.
                }
                else
                {
                   patiants.array[i].object["Symptoms"].array ~= parseJSON(symptomObject);         //Pick a few real symptoms.
                }
            }

        }

        string FakeSymptoms[];
        FakeSymptoms.length = symptomsList.length;
        for (int f = 0; f < noFakeSimps; f++)   //Get real symptoms 0 to max. Will sometimes pick 0
        {
            writeln("Choosing fake symptoms");
            symptom = pickSymptom(symptomsList, "", fakeend, fakestart);

            while(checkChoosen(choosenFakeSymptomsList, symptom) == true)
            {
                symptom = pickSymptom(symptomsList, "", fakeend, fakestart);
            }

            string symptomObject = format("{\"name\": \"%s\"},", chompPrefix(symptom, to!string(type)));
            if (f == 0 && noRealSimps == 0)
            {
                patiants.array[i].object["Symptoms"] = JSONValue([parseJSON(symptomObject)]);       //Pick a few real symptoms.
            }
            else
            {
                patiants.array[i].object["Symptoms"].array ~= parseJSON(symptomObject);         //Pick a few real symptoms.
            }
            choosenFakeSymptomsList ~= symptom;
        }

        i++;
    }


    foreach(int p, JSONValue patiant; patiants.array)
    {
        string patiantJSON = patiant.toPrettyString();
        append("Patiants.json", patiantJSON);
        append("Patiants.json", "\n");
//        writeln(patiantJSON);
    }

        






}
