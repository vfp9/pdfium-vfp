LPARAMETERS tvType, tvReference


DO CASE
CASE PCOUNT() = 1 AND VARTYPE(m.tvType)="O" && Initialization with external Env
    PdfiumReportAppInit(m.tvType)
    RETURN

CASE PCOUNT() = 1 AND m.tvType = .T.  && Initialization with default Env
    PdfiumReportAppInit()
    RETURN

CASE PCOUNT() = 1 AND m.tvType = .F. && Release
    PdfiumReportAppRelease()
    RETURN

CASE PCOUNT() = 0
    RETURN
    
ENDCASE


IF VARTYPE(m._PdfiumReportEnv) <> "O"
    ERROR "PdfiumReport.App was not initialized. Execute DO PdfiumReport.app WITH [ .T. | Pdfium_env object ]"
ENDIF    


LOCAL lcAppPath
lcAppPath = STREXTRACT(SYS(16)," ","",2,1+2)

IF VARTYPE(m._PdfiumReport) = "O" 
    m.tvReference = m._PdfiumReport
    RETURN
ENDIF

_PdfiumReport = NEWOBJECT("PdfiumReport", "pdfium-vfp.vcx", lcAppPath, m._PdfiumReportEnv)
m.tvReference = m._PdfiumReport


* Initialization of PdfiumReport.app global resources
* Must be called before usage PdfiumReport.app as global _REPORTOUTPUT
* To free resources call PdfiumReportAppRelease 
PROCEDURE PdfiumReportAppInit
    LPARAMETERS toEnv as pdfium_env of pdfium-vfp

    IF VARTYPE(m._PdfiumReportEnv)="O"
        RETURN
    ENDIF
    
    LOCAL lcAppPath
    lcAppPath = STREXTRACT(SYS(16)," ","",2,1+2)

    PUBLIC _PdfiumReportEnv
    m._PdfiumReportEnv = NEWOBJECT("Pdfium_env", "pdfium-vfp.vcx", lcAppPath)
    m._PdfiumReportEnv.setup(m.toEnv)

    PUBLIC _PdfiumReport
    m._PdfiumReport = NEWOBJECT("PdfiumReport", "pdfium-vfp.vcx", lcAppPath, m._PdfiumReportEnv)

ENDPROC

* Release PdfiumReport.app resources
PROCEDURE PdfiumReportAppRelease

    RELEASE _PdfiumReport
    RELEASE _PdfiumReportEnv

    
ENDPROC
