//
//  TimestampTests.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import Foundation
import HTML_Rendering_TestSupport
import InlineSnapshotTesting
import Testing

@testable import Markdown_HTML_Rendering

extension SnapshotTests.Timestamp {
    @Test func timestampWithSpeaker() {
        let timestamp = Timestamp(format: "1:23:45", speaker: "John")
        #expect(timestamp != nil)
        if let timestamp {
            assertInlineSnapshot(of: timestamp, as: .html) {
                """

                <div class="row-gap-0 flex-direction-1 display-2"><strong class="top-3 position-4 line-height-5 text-transform-6 font-size-7 color-8 color-9">John</strong>
                  <div>
                    <div class="width-10 text-align-11 position-12 line-height-13 margin-left-14 font-variant-numeric-15 text-decoration-16 font-size-17" id="t5025"><a class="color-18 color-19" data-timestamp="5025" href="#t5025">1:23:45</a>
                    </div>
                  </div>
                </div>
                """
            }
        }
    }

    @Test func timestampWithoutSpeaker() {
        let timestamp = Timestamp(format: "5:30", speaker: nil)
        #expect(timestamp != nil)
        if let timestamp {
            assertInlineSnapshot(of: timestamp, as: .html) {
                """

                <div class="row-gap-0 flex-direction-1 display-2">
                  <div>
                    <div class="width-3 text-align-4 position-5 line-height-6 margin-left-7 font-variant-numeric-8 text-decoration-9 font-size-10" id="t330"><a class="color-11 color-12" data-timestamp="330" href="#t330">5:30</a>
                    </div>
                  </div>
                </div>
                """
            }
        }
    }

    @Test func timestampShortFormat() {
        let timestamp = Timestamp(format: "0:45", speaker: nil)
        #expect(timestamp != nil)
        #expect(timestamp?.duration == 45)
    }
}
