//
// NewCommand.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import ArgumentParser
import Foundation

/// The command responsible for creating new Ignite sites.
/// This clones the starter repository from GitHub.
struct NewCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "new",
        abstract: "Creates a new Ignite site in a named folder."
    )

    /// Required argument: the name of the site to create.
    @Argument(help: "The name of the subfolder where you want the new site to be made. This must not currently exist.")
    var name: String

    /// Runs this command. Automatically called by Argument Parser.
    func run() throws {
        // Ensure we aren't trying to overwrite an existing site.
        if FileManager.default.fileExists(atPath: "./\(name)") {
            print("❌ Directory '\(name)' is not empty; aborting.")
        } else {
            // Clone from GitHub
            print("⚙️  Creating a new Ignite site in '\(name)'...")
            let result = try Process.execute(command: "git clone https://github.com/twostraws/IgniteStarter \(name)")

            if result.error.contains("fatal") {
                print("❌ Failed to create a new site. See errors below:")
                print(result.error)
            } else {
                // If everything worked, remove the Git history
                // for the IgniteStarter repo to avoid confusion.
                try Process.execute(command: "rm -rf \(name)/.git")
                print("✅ Success!")

                print("\nRun the following commands to edit your site in Xcode:\n\tcd \(name)\n\topen Package.swift\n")
                print("Tip: If you want to build with Xcode, go to the Product menu and choose Destination > My Mac.\n")
            }
        }
    }
}
