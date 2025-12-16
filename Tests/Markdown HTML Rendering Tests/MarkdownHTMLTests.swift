//
//  HTMLMarkdownTests.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 12/09/2025.
//

import Foundation
import Testing
import InlineSnapshotTesting
import HTML_Rendering_TestSupport
@testable import Markdown_HTML_Rendering

@Suite("Markdown.HTML Tests")
struct MarkdownHTMLTests {
    @Test("Basic markdown rendering")
    func basicMarkdownRendering() {
        let markdown = Markdown.HTML("# Hello World")
        #expect(markdown.tableOfContents.count >= 0)
    }
}

// MARK: - Snapshot Tests

extension SnapshotTests.MarkdownHTML {
    @Test func heading() {
        let markdown = Markdown.HTML("# Hello World")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5"><a class="visibility-6 top-7 top-8 position-9 display-0" id="hello-world"></a>
                <div class="position-9 padding-left-10 margin-left-11 padding-left-12 margin-left-13">
                  <h1 class="color-14 color-15">Hello World<a class="width-16 top-17 position-18 left-19 display-20 display-21 color-22 color-23" href="#hello-world"><svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="currentColor"><path d="M432-288H288q-79.68 0-135.84-56.23Q96-400.45 96-480.23 96-560 152.16-616q56.16-56 135.84-56h144v72H288q-50 0-85 35t-35 85q0 50 35 85t85 35h144v72Zm-96-156v-72h288v72H336Zm192 156v-72h144q50 0 85-35t35-85q0-50-35-85t-85-35H528v-72h144q79.68 0 135.84 56.23 56.16 56.22 56.16 136Q864-400 807.84-344 751.68-288 672-288H528Z"/></svg></a>
                  </h1>
                </div>
              </div>
            </div>
            """
        }
    }

    @Test func paragraph() {
        let markdown = Markdown.HTML("This is a paragraph.")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <p class="margin-6 padding-7 line-height-8">This is a paragraph.
                </p>
              </div>
            </div>
            """
        }
    }

    @Test func codeBlock() {
        let markdown = Markdown.HTML("""
            ```swift
            let x = 1
            ```
            """)
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <pre class="border-radius-6 padding-7 overflow-x-8 margin-bottom-9 margin-10 color-11 color-12"><code class="language-swift">let x = 1
            </code></pre>
              </div>
            </div>
            """
        }
    }

    @Test func blockquote() {
        let markdown = Markdown.HTML("> This is a quote")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <blockquote class="padding-6 margin-7 border-radius-8 border-9 border-10 background-color-11 background-color-12 color-13 color-14">
                  <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5"><strong class="color-15 color-16">Note</strong>
                    <p class="margin-17 padding-18 line-height-19">This is a quote
                    </p>
                  </div>
                </blockquote>
              </div>
            </div>
            """
        }
    }

    @Test func link() {
        let markdown = Markdown.HTML("[Link](https://example.com)")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <p class="margin-6 padding-7 line-height-8"><a href="https://example.com">Link</a>
                </p>
              </div>
            </div>
            """
        }
    }

    @Test func orderedList() {
        let markdown = Markdown.HTML("""
            1. First
            2. Second
            3. Third
            """)
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <ol class="row-gap-1 flex-direction-3 display-4">
                  <li>
                    <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                      <p class="margin-6 padding-7 line-height-8">First
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                      <p class="margin-6 padding-7 line-height-8">Second
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                      <p class="margin-6 padding-7 line-height-8">Third
                      </p>
                    </div>
                  </li>
                </ol>
              </div>
            </div>
            """
        }
    }

    @Test func unorderedList() {
        let markdown = Markdown.HTML("""
            - Apple
            - Banana
            - Cherry
            """)
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <ul class="margin-bottom-6 margin-top-7 row-gap-1 flex-direction-3 display-4">
                  <li>
                    <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                      <p class="margin-8 padding-9 line-height-10">Apple
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                      <p class="margin-8 padding-9 line-height-10">Banana
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                      <p class="margin-8 padding-9 line-height-10">Cherry
                      </p>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
            """
        }
    }

    @Test func table() {
        let markdown = Markdown.HTML("""
            | Header 1 | Header 2 |
            |----------|----------|
            | Cell 1   | Cell 2   |
            """)
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <table>
                  <thead>
                    <tr>
                      <th>Header 1
                      </th>
                      <th>Header 2
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Cell 1
                      </td>
                      <td>Cell 2
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            """
        }
    }

    @Test func emphasis() {
        let markdown = Markdown.HTML("*italic* and **bold** and ***both***")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <p class="margin-6 padding-7 line-height-8"><em>italic</em> and <strong>bold</strong> and <em><strong>both</strong></em>
                </p>
              </div>
            </div>
            """
        }
    }

    @Test func inlineCode() {
        let markdown = Markdown.HTML("Use `print()` to output")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <p class="margin-6 padding-7 line-height-8">Use <code>print()</code> to output
                </p>
              </div>
            </div>
            """
        }
    }

    @Test func image() {
        let markdown = Markdown.HTML("![Alt text](image.png)")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <p class="margin-6 padding-7 line-height-8">
                  <div class="row-gap-9 max-width-2 flex-direction-3 display-4 align-items-10"><a href="image.png"><img class="border-radius-11 margin-right-12 margin-left-13 margin-bottom-14 margin-top-15" alt src="image.png"></a>
                  </div>
                </p>
              </div>
            </div>
            """
        }
    }

    @Test func thematicBreak() {
        let markdown = Markdown.HTML("Before\n\n---\n\nAfter")
        assertInlineSnapshot(of: markdown, as: .html) {
            """

            <div class="display-0">
              <div class="row-gap-1 max-width-2 flex-direction-3 display-4 align-items-5">
                <p class="margin-6 padding-7 line-height-8">Before
                </p>
                <div class="margin-6 padding-7 line-height-8 margin-bottom-9 margin-top-10">
                  <hr class="margin-11 border-top-12 border-left-13 border-bottom-14 border-right-15">
                </div>
                <p class="margin-6 padding-7 line-height-8 margin-bottom-9 margin-top-10 margin-6 padding-7 line-height-8">After
                </p>
              </div>
            </div>
            """
        }
    }

    @Test func tableOfContents() {
        let markdown = Markdown.HTML("""
            # Section 1
            @T(0:00)
            Content
            ## Section 1.1
            @T(1:00)
            More content
            # Section 2
            @T(2:00)
            Final content
            """)
        #expect(markdown.tableOfContents.count == 3)
    }
}
