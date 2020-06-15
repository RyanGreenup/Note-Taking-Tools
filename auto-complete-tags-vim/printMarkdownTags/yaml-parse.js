// //////////////////////////////////////////////////////////
// ////////// Load Libraries ////////////////////////////////
// //////////////////////////////////////////////////////////

const path = require('path');
const fs = require('fs');
const yamlFront = require('yaml-front-matter');
let debugFlag = false;
let glob = require('glob');

////////////////////////////////////////////////////////////
/////////// Change Directory ///////////////////////////////
////////////////////////////////////////////////////////////

if (process.argv[2] == undefined) {
    const path = "./";
    if (debugFlag) {
        console.log(`No Path Detected, using this directory ${process.argv[1]}`)
        console.log("Remember to use $HOME not ~")
    }
} else {
    const path = process.argv[2];
    process.chdir(path);
    if (debugFlag) {
        console.log(`Using Specified Directory ${process.argv[2]}`)   
    }
}


// //////////////////////////////////////////////////////////
// ////////////// Get File Names/////////////////////////////
// //////////////////////////////////////////////////////////

let noteFilePathList = glob.sync('./**/*.md')

// //////////////////////////////////////////////////////////
// ////////////// Loop over the File Names///////////////////
// ///////////////    and Print Tags  ///////////////////////
// //////////////////////////////////////////////////////////


for (let j = 0; j < noteFilePathList.length; j++) {
    const filePath = noteFilePathList[j];
    // console.log(noteFileName)

    // We need to extract the text from the file name
    // into a string variable
    let file_text = fs.readFileSync(filePath, "utf-8");

    // Pull ou the YAML header as an object using
    // the yaml-front-matter package.
    // This is a JavaScriptObect
    let ymlExtract = yamlFront.loadFront(file_text);
    let thetags = ymlExtract.tags;
    // Extract the tags as an array.

    // Undefined has no length so check before
    // using the number of tags to create a loop
    if (thetags != undefined) {

        // We need to individually print each tag item
        // so that it gets the luxury of a new line
        for (let i = 0; i < thetags.length; i++) {
            console.log(thetags[i])
        }
    }
}
