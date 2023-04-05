/**
 * These tests check that directory.json and quest-to-test.json are correctly configured for public deployment.
 * Specifically:
 *    1. directory.json should contain all quests with matching version numbers
 *    2. directory.json should not contain extraneous quests
 *    3. All entries in each files-to-test.json should be valid paths
 *    4. All public contracts and scripts (i.e. in "/_contracts" and "/_scripts") not in files-to-test.json
 *       must match their private counterparts
 */

"use strict";
const { assert } = require("chai");
const fs = require("fs");
const path = require("path");
const { getFiles, equalFiles, getContractDefinition } = require("./helpers/filehelper.js");
const { ast } = require("@ngquests/test-helpers");

const directory = require("../campaigns/directory.json");

const campaignDirectoryPath = path.resolve(__dirname, "..", "campaigns");

/**
* Asserts files in template contracts have complementary ASTs to their solutions.
*/
async function checkTemplates(questPath, solutionFiles) {

  for (const solutionFile of solutionFiles) {

    const solutionPath = path.resolve(questPath, solutionFile);
    const solutionDefinition = getContractDefinition(solutionPath);

    const templatePath = solutionPath.replace("/contracts", "/_contracts");
    const templateDefinition = getContractDefinition(templatePath);

    const err = `${solutionFile} has misconfigured templates`;
    ast.isSubAst(templateDefinition, solutionDefinition, err);
  }

}


/**
* Asserts files in public `contracts` matches files in private `_contracts`.
* Excludes files found in toExclude.
*/
async function compareFiles(questPath, toExclude) {

  const userContracts = await getFiles(path.join(questPath, "_contracts"));
  const solutionContracts = await getFiles(path.join(questPath, "contracts"));

  var unionContracts = [...new Set([...userContracts, ...solutionContracts])];

  for (const contract of unionContracts) {
    
    if (toExclude.some(filepath => filepath.endsWith(contract))) { continue; }

    const userContract = path.resolve(questPath, "_contracts", contract);
    const solutionContract = path.resolve(questPath, "contracts", contract);

    assert(
      equalFiles(userContract, solutionContract), 
      `User contract mismatch with solution: ${contract}`
    );

  }
}

describe("Deployment Configuration Test", async function() {

  it("directory.json should be correctly configured", async function() {

    for (const campaign of directory) {

      const campaignPath = path.resolve(campaignDirectoryPath, campaign.name);
      
      for (const quest of campaign.quests) {
        const questPath = path.resolve(campaignPath, quest.name);

        // Test valid name
        assert(fs.existsSync(questPath), `${questPath} does not exist`);

        // Test valid name
        const version = require(path.resolve(questPath, "package.json")).version;
        assert(version == quest.version, `"${quest.name}" has mismatched versions`);

        // Test valid type
        assert(quest.type == "ctf" || quest.type == "build", `${quest.name} has an invalid type`)
        const contractsPath = quest.type == "ctf"
          ? path.join(questPath, "contracts_")
          : path.join(questPath, "_contracts");
        
        assert(fs.existsSync(contractsPath),`${quest.name} might have an incorrect type`);

        // Test valid number of parts
        const lastPartPath = path.join(questPath, `description/part${quest.parts}.md`);
        const invalidPartPath = path.join(questPath, `description/part${quest.parts + 1}.md`);
        assert(
          fs.existsSync(lastPartPath) && !fs.existsSync(invalidPartPath),
          `${quest.name} might have an incorrect number of parts`
        );
        
      }

      const numQuests = fs.readdirSync(campaignPath, { withFileTypes: true })
        .filter(entry => entry.isDirectory() && entry.name != "media")
        .length;
      
      assert(
        numQuests == campaign.quests.length, 
        `"${campaign.name}" has mismatched number of quests`
      );
      
    }

  });

  it("files-to-test.json should be correctly configured", async function() {

    for (const campaign of directory) {

      for (const quest of campaign.quests) {

        const questPath = path.resolve(campaignDirectoryPath, campaign.name, quest.name);

        // If quest is CTF (i.e. has no /contracts folder), skip
        if (!fs.existsSync(path.resolve(questPath, "contracts"))) { 
          continue; 
        }

        // Ensure build quest has files-to-test.json
        const filesToTestPath = path.resolve(questPath, "files-to-test.json");
        assert(fs.existsSync(filesToTestPath), `${quest.name} is missing files-to-test.json`); 
        
        const filesToTest = require(filesToTestPath)
          .map(fileName => path.resolve(questPath, fileName));
          for (const filePath of filesToTest) {
        
          assert(fs.existsSync(filePath), `Invalid file path: ${filePath} in ${filesToTestPath}`);
          assert(
            filePath.endsWith(".sol") || filePath.endsWith(".json"), 
            `File must either be *.sol or *.json: ${filePath} in ${filesToTestPath}`
          );
        }

        for (const filePath of filesToTest) {
          assert(fs.existsSync(filePath), `Invalid file path: ${filePath} in ${filesToTestPath}`);
        }

        // For files-to-test that are not exactly "templates"
        const notTemplatesPath = path.resolve(questPath, "not-templates.json");
        const notTemplates = fs.existsSync(notTemplatesPath)
          ? require(notTemplatesPath).map(file => path.resolve(questPath, file))
          : [];

        // Test that all other common contracts/scripts 
        // between public and private folder share the same code
        // (This ensures there is no missing file in files-to-test.json)
        await compareFiles(questPath, [...filesToTest, ...notTemplates]);

      }
    }

  })

  it("template contracts should match solution contracts", async function() {
    for (const campaign of directory) {

      for (const quest of campaign.quests) {
        const questPath = path.resolve(campaignDirectoryPath, campaign.name, quest.name);

        // If quest is CTF (i.e. has no /contracts folder), skip
        if (!fs.existsSync(path.resolve(questPath, "contracts"))) { 
          continue; 
        }

        // For files-to-test that are not exactly "templates"
        const notTemplatesPath = path.resolve(questPath, "not-templates.json");

        const notTemplates = fs.existsSync(notTemplatesPath)
          ? require(notTemplatesPath)
          : [];

        const templateFiles = require(path.resolve(questPath, "files-to-test.json"))
          .filter(filepath => filepath.startsWith("contracts"))
          .filter(filePath => !notTemplates.includes(filePath));
          
        await checkTemplates(questPath, templateFiles);
      }

    }
  });


});