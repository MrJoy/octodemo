# DSL TODOs:

* Convert to Commander.
    * Expose command/argument metadata to Commander.
    * Change DSL to support argument mechanisms that Commander supports (types, etc).
    * Way to handle positional args?  Something like:

        ```ruby
        scaffold :project do
          arguments do
            title, :required => false, :type => String # First positional arg becomes args.title
            something_else, :required => false, :type => Fixnum # Probably can only have one optional arg sanely...
          end
          options do
            # See my previous `arguments` DSL...
          end
          # ...
        end
        ```

* "Bare" mode (for scaffolding a site/plugin).
    * Need some form of `run`/`shell`/`exec` DSL command.
        * For things like `git init`.
        * Should be as safe to use as feasible.  I.E. array of params, automatic shell escaping.
* Implement file ops.
    * Shellescape for filenames, etc.
        * Spit out warnings, and/or ask for confirmation from the user when escaping does something significant, so users don't wind up with evil filenames.
            * I.E. `Shellescape` will make it so you can have a `file with "quotes in the name"` -- but it's unwise to do so.
    * Helper for string-to-sane-filename.
        * Apply our preferred conventions for things like title-to-filename rules in a convenient and reusable manner.
* Dry-run mode that performs no actual file actions, but generates information about what would be done.
    * Including manifest/history info.
* Callback/interface for producing output, and/or interrogating the user.
    * Should know about force-yes, force-no and should behave automatically by short-circuiting user interrogation accordingly.
* Be able to ask Octopress about defaults (such as default new page/post type).
* Possibly time-zone related helpers.
    * `.to_filename` ("YYYY-MM-DD")
    * `.to_frontmatter` (Jekyll conventions, or whatever...)
    * Type handling for arguments, so any time-zone conversions can be automatically addressed.
* Way to add comments to front-matter?  This might be hard to do without making our own YAML generator which we do NOT want to do.  Alternatively, allow `:frontmatter` to be a string that can be hand-synthesized but that's just kicking the can down the road and will likely lead to a mess.

    ```ruby
    page "foo", :frontmatter => { :external_url => :nil }, :frontmatter_comments => {
      :before_external_url => 'This will be placed on a separate comment-line above the external_url key.',
      :after_external_url => 'This will be placed on a separate comment-line below the external_url key.',
      :suffix_external_url => 'This will be placed on the same line as the external_url key.'
    }
    ```

* Rename `template` helper to `resource`.
* Initial core plugins, as dependencies of Octopress itself:
    * New post.
    * New page.
    * Main theme.
    * Deployment tools.
        * RSync
        * Github Pages
        * Do we want to include S3 out of the box, or should I release this separately?
    * New site.
        * Sets up git repo.
        * Default pre-commit hook that warns about `:path` references in Gemfile.lock.
            * This will help plugin authors avoid certain mistakes that may bite them in the rear down the road but not be obvious right away.
    * New plugin. (very meta!)
        * Should inherit Rubocop rules and tasks so submitters can use up-to-date Rubocop rules to help make submissions easier, etc.
    * Sidebars.
* Generators should refuse to clobber uncommitted files.
    * Should strongly warn and/or refuse to clobber _untracked_ files.
* Initialization/upgrade/downgrade/uninstall API.
    * Keep current plugin => version mappings.
        * Run `installed`, `upgraded`, `downgraded`, etc when metadata is out of sync with Bundler info.
            * Should this be a separate Octopress command -- perhaps bomb out if it hasn't been run, saying 'please run "octopress plugins sync"' or some such?
        * Uninstall is a bit of a special case, since no plugin will exist anymore -- but we can:
            * Remove auto-installed files.
            * Offer to remove generated content for the user.
        * Do we want to auto-commit changes to the history/manifest metadata on behalf of the user?
    * Keep manifest of generated/copied artifacts.
        * Record:
            * All things installed, with version.
            * All things generated, with version.
            * ... except for 'bare' generators (I.E. new site/plugin), obviously.
        * Metdata has:
            * Plugin version used at time of operation.
            * UTC Timestamp, microsecond resolution at time of operation.
            * Affected path.
            * Operation.
                * Created
                * Removed
                * Modified
                * Skipped (may be useful to know when a user didn't auto-upgrade a file, etc).
            * May be useful to also have an overarching notion of `action`, I.E. the scaffold that was run, the args provided, etc.
      * To avoid git conflicts, I recommend a structure of the form:
          * `.manifests` or `.history` or whatever...
              * `<plugin_name>`
                  * `version.yml` (current plugin version)
                  * `<utc_timestamp_at_microsecond_resolution>.yml` (or possibly use SHA of contents + timestamp -- want universally unique name)
    * Plugins _may_ (but need not) implement `installed`, `upgraded`, and/or `downgraded`.
        * Making this API future-proof is hard, so we should discourage its use for now.
    * Recording history info now gives us a way to implement upgrade/downgrade/uninstall/etc at a later time.
        * Plugins may also need to specify rules, ultimately.  E.G. `upgraded` can callback and ask for info about anything in _posts to make a best-guess about how to proceed.
    * For 3.0, don't do automatic implementations of upgrade/downgrade ops, but do call API methods.
        * Gives us a way to hack something expedient in for core plugins until generalized behavior is in place.
        * Mess is compartmentalized until we can handle this more gracefully.
        * Perhaps, don't call anything but `installed` for plugins that aren't direct dependencies of Octopress itself, so people don't come to depend on an API that will likely change?
* Longer term:
    * Upgrading/downgrading:
        * Construct state-of-the-world to provide to plugins in `upgraded`/`downgraded` operations...
            * Play out all history files for a plugin, in timestamp order, keeping a hash keyed by path, with the value being the most recent version to modify the file.
                * Possibly also include the full history as part of the value.
            * Strip out any files that don't exist in the source tree.
            * Produce a list of 'skipped' files that haven't subsequently been auto-updated (user may have updated by hand, plugins should tread lightly).
        * Be able to ask the user about removing cruft when upgrading/downgrading a plugin.
        * Provide user a way to update all generated assets to a newer version of a plugin.
            * We can do 'cruft removal' via metadata.
            * Plugin needs to provide means of going from one version to another.
                * I have some ideas on how to make this easier for plugin authors to get right.
    * Scaffold DSL:
        * Provide a way to glob multiple positional args together?
            * Tricky unless it's only allowed for the last argument(s).
        * Provide a format-neutral way of describing content so that it can be generated in the markup language of the user's choice:

            ```ruby
            page "blah" do
              heading 1, "Meh"
              para "sjdlasdjlaskjdlskajdsalk"
              para do # Do we auto-word-wrap?
                text "bleah#{italicize("meh")}" # Can we do this?
                text "bleah" # Spaces between text elements (`join(' ')`) if we can do the above, no spaces (`join()`) if we can't...
                bold "meh"
                text "whatever"
              end
              table do
                row do
                  column "aklhaldhasdj"
                  column do
                    text "jshjkahsdjaks"
                    # ...
                  end
                end
              end
            end
            ```

        * But what about supporting features that not all markup syntaxes support?  Options:
            1. Don't support such features.
            2. Produce a comment showing the structural info about what the plugin wanted to do, outlining why it can't be done, etc.
            3. Produce simple HTML.
            4. Both #2 and #3 above.
