# Doxygen related code
find_package(Doxygen)
if(DOXYGEN_FOUND)

  set(TAGFILES
    "${QT_DOC_DIR}/html/qt.tags=http://doc.qt.nokia.com/4.${QT_VERSION_MINOR}")
  set(TAGFILES
    "${TAGFILES} ${CMAKE_CURRENT_BINARY_DIR}/openbabel.tags=http://openbabel.org/api")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
    ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)

  # Write out a cmake script to download the Open Babel tag file
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/DownloadOBTag.cmake
"file(DOWNLOAD http://openbabel.org/api/openbabel.tags
  ${CMAKE_CURRENT_BINARY_DIR}/openbabel.tags SHOW_PROGRESS)")

  add_custom_target(download_ob_tagfile
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/DownloadOBTag.cmake)

  add_custom_target(doxygen
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/api
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
    DEPENDS download_ob_tagfile)
endif()

# find the required tools
find_program(DOCBOOK2PDF_EXECUTABLE docbook2pdf)
find_program(DOCBOOK2HTML_EXECUTABLE docbook2html)

if( DOCBOOK2PDF_EXECUTABLE AND DOCBOOK2HTML_EXECUTABLE )
   # create a target to build pdf docs
   add_custom_target(pdfdocs COMMAND ${DOCBOOK2PDF_EXECUTABLE} -o pdf
      ${CMAKE_CURRENT_SOURCE_DIR}/index.docbook )

   # create a target to build html docs
   add_custom_target(htmldocs COMMAND ${DOCBOOK2HTML_EXECUTABLE} -o html
      ${CMAKE_CURRENT_SOURCE_DIR}/index.docbook )

   # create a helper target to build both
   # if this is always wanted, the two custom targets above
   # can also be combined into one custom target with two COMMANDs
   #add_custom_target(alldocs ALL)
   add_custom_target(alldocs)
   add_dependencies(alldocs pdfdocs htmldocs)

   #FILE(GLOB avogadro_HTML RELATIVE ${CMAKE_CURRENT_BINARY_DIR}/html/ "*.html")
   #INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/pdf/index.pdf  DESTINATION share/doc/avogadro/pdf/ OPTIONAL)
   #INSTALL(FILES ${avogadro_HTML}  DESTINATION share/doc/avogadro/html/ OPTIONAL)

else( DOCBOOK2PDF_EXECUTABLE AND DOCBOOK2HTML_EXECUTABLE )
   message(STATUS "docbook tools not found, doc targets disabled")
endif( DOCBOOK2PDF_EXECUTABLE AND DOCBOOK2HTML_EXECUTABLE )

# Manpages
if(UNIX)
   file(GLOB man_1 *.1)
   install(FILES ${man_1} DESTINATION ${SHARE_INSTALL_PREFIX}/man/man1)
endif(UNIX)
