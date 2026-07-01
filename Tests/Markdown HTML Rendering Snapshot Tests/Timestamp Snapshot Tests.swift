//
//  Timestamp Snapshot Tests.swift
//  swift-markdown-html-rendering
//

import HTML_Rendering_Core_Test_Support
import Markdown_HTML_Rendering
import Testing

extension `Snapshot Tests`.`Timestamp` {
    @Test
    func `timestamp with speaker renders speaker name`() {
        let timestamp = Timestamp(format: "1:23:45", speaker: "John")
        #expect(timestamp != nil)
        if let timestamp {
            snapshot(as: .html) { timestamp }  matches: {
                """
                <div class="row-gap-0 flex-direction-1 display-2"><strong class="top-3 position-4 line-height-5 text-transform-6 font-size-7 color-8 color-9">John</strong>
                  <div class="top-3 position-4 line-height-5 text-transform-6 font-size-7 color-8 color-9">
                    <div class="width-10 text-align-11 position-12 line-height-13 margin-left-14 font-variant-numeric-15 text-decoration-16 font-size-17" id="t5025"><a class="color-18 color-19" data-timestamp="5025" href="#t5025">1:23:45</a>
                    </div>
                  </div>
                </div>
                """
            }
        }
    }

    @Test
    func `timestamp without speaker renders time only`() {
        let timestamp = Timestamp(format: "5:30", speaker: nil)
        #expect(timestamp != nil)
        if let timestamp {
            snapshot(as: .html) { timestamp } matches: {
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

    @Test
    func `short timestamp renders correctly`() {
        let timestamp = Timestamp(format: "0:45", speaker: nil)
        #expect(timestamp != nil)
        #expect(timestamp?.duration == 45)
    }
}
