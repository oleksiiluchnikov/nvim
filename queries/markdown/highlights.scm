; Dataview Fields
((inline) @inline_with_dataview_field
    (#match? @inline_with_dataview_field "\\b[a-zA-Z\-_]+::\\b"))

; Dataview and other code blocks
(fenced_code_block
  ((info_string) @language (#eq? @language "dataviewjs"))
  (code_fence_content) @javascript)

(fenced_code_block
  ((info_string) @language (#eq? @language "dataview"))
  (code_fence_content) @query)

; Wikilinks and aliases
; ((link) @wikilink (#match? @wikilink "^\\[\\[.*\\]\\]$"))
; ((link_text) @link_alias (#match? @link_alias "\\|"))
;
; ; Tags
; ((tag) @tag (#match? @tag "^#[A-Za-z0-9_/-]+"))
;
; ; Callouts/Admonitions

;   (quote_prefix) @quote_marker
;   ((paragraph) @callout_content
;     (#match? @callout_content "^\\[!(NOTE|WARNING|INFO|TIP|IMPORTANT|CAUTION)\\]")))

; Metadata section
(section
  ((paragraph) @frontmatter_marker
    (#eq? @frontmatter_marker "---"))
  (paragraph) @yaml
  ((paragraph) @frontmatter_marker
    (#eq? @frontmatter_marker "---")))

; Task Lists with Priorities
((task_list_marker_checked) @task_done (#set! conceal "✓"))
((task_list_marker_unchecked) @task_pending (#set! conceal "□"))
((paragraph) @high_priority (#match? @high_priority "\\[\\!\\]"))
((paragraph) @medium_priority (#match? @medium_priority "\\[\\?\\]"))
((paragraph) @low_priority (#match? @low_priority "\\[-\\]"))

; Inline LaTeX
((inline) @latex (#match? @latex "\\$.*\\$"))
; (math_environment) @latex
;
; ; Internal Obsidian links
; ((inline) @internal_link (#match? @internal_link "\\!\\[\\[.*\\]\\]"))
;
; ; Comments
; ((html_comment) @comment)
;
; ; Embeds and Transclusions
; ((inline) @embed (#match? @embed "!\\[\\[.*\\]\\]"))
;
; ; Highlighted text
; ((inline) @highlight (#match? @highlight "==.*=="))
;  (code_fence_content) @javascript)
