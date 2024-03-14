const { readFileSync, writeFileSync } = require("fs");

const standardVersion = require("standard-version");

async function prepareVersion(options = {}) {
  try {
    // Read the current wrTemplateVersion
    const wrappidMeta = JSON.parse(readFileSync(".wrappid/wrappid.meta.json", "utf-8"));
    const currentVersion = wrappidMeta.wrTemplateVersion;

    // Extract version components
    const [major, minor, patch] = currentVersion.split(".");

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
    await standardVersion({ /* silent: true */ });

    // Create a git tag using the new wrTemplateVersion
    // await exec(`git tag v${newVersion}`);

    // eslint-disable-next-line no-console
    console.log(`Successfully created tag: v${newVersion}`);
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("An error occurred:", error);
    // Consider adding more specific error handling logic here
  }
}

// Parse command-line arguments
const args = process.argv.slice(2);

console.log("Command-line arguments:", args);

const options = {};

for (let i = 0; i < args.length; i += 2) {
  const option = args[i].replace(/--?/, "");
  const value = args[i + 1];

  if (option === "r") {
    options.release = value;
  } else if (option === "p") {
    options.preid = value;
  } else {
    // Handle invalid options (optional)
  }
}

console.log("Parsed options:", options);

prepareVersion(options);