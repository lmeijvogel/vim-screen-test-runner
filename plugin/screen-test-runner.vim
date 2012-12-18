function! RunCurrentTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call s:SetTestFile()

    call s:DetermineTestRunner()
  endif

  " If the current file is not a test file, run the previously defined file

  call s:ExecCommand( g:bjo_test_runner ." ". g:bjo_test_file )
endfunction

function! RunCurrentLineInTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call s:SetTestFileWithLine()

    call s:DetermineTestRunner()
  end

  call s:ExecCommand(g:bjo_test_runner ." ". g:bjo_test_file)
endfunction

function! s:SetTestFile()
  let g:bjo_test_file=@%
endfunction

function! s:DetermineTestRunner()
  if match(expand('%'), '\.feature$') != -1
    call s:SetTestRunner("cucumber")
  elseif match(expand('%'), '_spec\.rb$') != -1
    call s:SetTestRunner("rspec")
  else
    call s:SetTestRunner("ruby -Itest")
  endif
endfunction

function! s:SetTestRunner(runner)
  let g:bjo_test_runner=a:runner
endfunction

function! s:SetTestFileWithLine()
  let g:bjo_test_file=@%
  let g:bjo_test_file_line=line(".")
endfunction

function! s:ExecCommand(command)
  exec "wa"

  let theCommand = "bundle exec ". a:command
  if exists("g:ScreenShellActive") && (g:ScreenShellActive == 1)
    exec "call g:ScreenShellSend(\"". theCommand ."\")"
  else
    exec "!".theCommand
  endif
endfunction
