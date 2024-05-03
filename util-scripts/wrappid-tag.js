const { exec } = require("child_process");
const { readFileSync, writeFileSync } = require("fs");

const standardVersion = require("standard-version");

async function prepareVersion(options = {}) {
  try {
    // Read the current wrTemplateVersion
    let wrappidMeta = JSON.parse(readFileSync(".wrappid/wrappid.meta.json", "utf-8"));
    let currentVersion = wrappidMeta.wrTemplateVersion;

    // Extract version components
    let [major, minor, patch] = currentVersion.split(".");

    // Update version based on options
    let newVersion;

    if (options.release) {
      switch (options.release.toLowerCase()) {
        case "patch":
          newVersion = `${major}.${minor}.${parseInt(patch) + 1}`;
          break;

        case "minor":
          newVersion = `${major}.${parseInt(minor) + 1}.0`;
          break;

        case "major":
          newVersion = `${parseInt(major) + 1}.0.0`;
          break;

        default:
          // eslint-disable-next-line no-console
          console.error(`Invalid release type: ${options.release}`);
          return;
      }
    } else if (options.preid) {
      // Handle pre-release versioning if provided
      newVersion = `${major}.${minor}.${patch}-${options.preid}`;
    } else {
      // eslint-disable-next-line no-console
      console.error("Missing required option: --release (-r) or --preid (-p)");
      return;
    }

    // Update the wrTemplateVersion in the original package.json
    wrappidMeta.wrTemplateVersion = newVersion;
    writeFileSync(".wrappid/wrappid.meta.json", JSON.stringify(wrappidMeta, null, 2));

    // Use standard-version internally
    await standardVersion({ skip: { commit: true, tag: true } });
   
    // await new Promise((resolve, reject) => {
    //   exec("npm i", (error, stdout, stderr) => {
    //     if (error) {
    //       // eslint-disable-next-line no-console
    //       console.error(`Error running npm installation: ${error.message}`);
    //       reject(error);
    //       return;
    //     }
    //     if (stderr) {
    //       // eslint-disable-next-line no-console
    //       console.error(`Error running npm installation: ${stderr}`);
    //       reject(stderr);
    //       return;
    //     }
    //     resolve();
    //   });
    // });
    // create commit message
    await new Promise((resolve, reject) => {
      exec("bash commit-message.sh " + newVersion, (error, stdout, stderr) => {
        if (error) {
          // eslint-disable-next-line no-console
          console.error(`Error generating commit message: ${error.message}`);
          reject(error);
          return;
        }
        if (stderr) {
          // eslint-disable-next-line no-console
          console.error(`Error generating commit message: ${stderr}`);
          reject(stderr);
          return;
        }
        resolve();
      });
    });

    // Stage the wrappid.meta.json file
    await new Promise((resolve, reject) => {
      // eslint-disable-next-line quotes
      exec(`git add ./package.json ./package-lock.json ./.wrappid/wrappid.meta.json ./CHANGELOG.md 2>/dev/null`, (error, stdout, stderr) => {
        if (error) {
          // eslint-disable-next-line no-console
          console.error(`Error staging wrappid.meta.json: ${error.message}`);
          reject(error);
          return;
        }
        if (stderr) {
          // eslint-disable-next-line no-console
          console.error(`Error staging wrappid.meta.json: ${stderr}`);
          reject(stderr);
          return;
        }
        resolve();
      });
    });
    
    // eslint-disable-next-line no-console
    console.log("Successfully added changes");

    // Stage the wrappid.meta.json file
    await new Promise((resolve, reject) => {
      // eslint-disable-next-line quotes
      exec(`git commit -F commit-message.txt --no-verify`, (error, stdout, stderr) => {
        if (error) {
          // eslint-disable-next-line no-console
          console.error(`Error staging wrappid.meta.json: ${error.message}`);
          reject(error);
          return;
        }
        if (stderr) {
          // eslint-disable-next-line no-console
          console.error(`Error staging wrappid.meta.json: ${stderr}`);
          reject(stderr);
          return;
        }
        resolve();
      });
    });

    // eslint-disable-next-line no-console
    console.log(`Successfully committed changes for version: ${newVersion}`);
    
    // Create a tag for the new version
    await new Promise((resolve, reject) => {
      exec(`git tag v${newVersion}`, (error, stdout, stderr) => {
        if (error) {
          // eslint-disable-next-line no-console
          console.error(`Error creating tag for version ${newVersion}: ${error.message}`);
          reject(error);
          return;
        }
        if (stderr) {
          // eslint-disable-next-line no-console
          console.error(`Error creating tag for version ${newVersion}: ${stderr}`);
          reject(stderr);
          return;
        }
        resolve();
      });
    });

    // eslint-disable-next-line no-console
    console.log(`Successfully created tag: v${newVersion}`);
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("An error occurred:", error);
    // Consider adding more specific error handling logic here
  }
}

// Parse command-line arguments
let args = process.argv.slice(2);

// eslint-disable-next-line no-console
console.log("Command-line arguments:", args);

let options = {};

for (let i = 0; i < args.length; i += 2) {
  let option = args[i].replace(/--?/, "");
  let value = args[i + 1];

  if (option === "r") {
    options.release = value;
  } else if (option === "p") {
    options.preid = value;
  } else {
    // Handle invalid options (optional)
  }
}

// eslint-disable-next-line no-console
console.log("Parsed options:", options);

prepareVersion(options);
