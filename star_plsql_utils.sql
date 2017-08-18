create or replace function apex_42_copy_ir (
  pUser           in  VARCHAR2,                   -- AKHTAR
  pReportID       in  NUMBER,                     -- 1235
  pAction         in  VARCHAR2                    -- I (Ignore) K (Keep Existing) R Replace Existing
)   return              VARCHAR2 is

  vReportID           NUMBER          :=  0;      -- Unique Report ID
  vReportSeq          NUMBER          :=  0;      -- Unique Report Sequence
  vReportName         VARCHAR2(255)   :=  '';     -- Report Name
  vReportPage         NUMBER          :=  '0';    -- Report Page Name
  RtnMsg              VARCHAR2(4000)  :=  null;   -- Return msg

  Begin
    Select NAME, PAGE_ID into vReportName, vReportPage From apex_040200.wwv_flow_worksheet_rpts Where ID = pReportID;

    IF pAction = 'C' then
      RtnMsg := vReportName || ' has been copied.';
    END IF;

    IF pAction = 'I' then
      RtnMsg := vReportName || ' has been ignored.';
    END IF;

    IF pAction = 'K' then
      vReportName := vReportName || '_COPY';
      RtnMsg := 'Report has been copied as ' || vReportName;
    END IF;

    IF pAction = 'R' THEN
      for i in (Select ID as vDelReportID from apex_040200.wwv_flow_worksheet_rpts where NAME = vReportName and PAGE_ID = vReportPage and APPLICATION_USER = pUser) loop
        delete from apex_040200.wwv_flow_worksheet_rpts where id = i.vDelReportID;
        delete from apex_040200.wwv_flow_worksheet_computation where report_id = i.vDelReportID;
        delete from apex_040200.wwv_flow_worksheet_conditions where report_id = i.vDelReportID;
        delete from apex_040200.WWV_FLOW_WORKSHEET_GROUP_BY where report_id = i.vDelReportID;
      end loop;
      RtnMsg := 'Report has been replaced.';
    END IF;

    IF pAction <> 'I' then
      --      Create a record in
      --      Schema:     apex_040200
      --      Table:      wwv_flow_worksheet_rpts
      --      PK:         wwv_flow_id.next_val
      Begin
        -- Get Report ID
        Select apex_040200.wwv_flow_id.next_val INTO vReportID From Dual;
        -- Get Next Display Sequence for Report
        Select MAX(REPORT_SEQ) + 10 INTO vReportSeq From apex_040200.wwv_flow_worksheet_rpts Where FLOW_ID = v('APP_ID');

        insert into
          apex_040200.wwv_flow_worksheet_rpts (
            ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    FLOW_ID
            ,    PAGE_ID
            ,    SESSION_ID
            ,    BASE_REPORT_ID
            ,    APPLICATION_USER
            ,    NAME
            ,    DESCRIPTION
            ,    REPORT_SEQ
            ,    REPORT_TYPE
            ,    REPORT_ALIAS
            ,    STATUS
            ,    VIEW_MODE
            ,    CATEGORY_ID
            ,    AUTOSAVE
            ,    IS_DEFAULT
            ,    DISPLAY_ROWS
            ,    PAGINATION_MIN_ROW
            ,    REPORT_COLUMNS
            ,    SORT_COLUMN_1
            ,    SORT_DIRECTION_1
            ,    SORT_COLUMN_2
            ,    SORT_DIRECTION_2
            ,    SORT_COLUMN_3
            ,    SORT_DIRECTION_3
            ,    SORT_COLUMN_4
            ,    SORT_DIRECTION_4
            ,    SORT_COLUMN_5
            ,    SORT_DIRECTION_5
            ,    SORT_COLUMN_6
            ,    SORT_DIRECTION_6
            ,    BREAK_ON
            ,    BREAK_ENABLED_ON
            ,    CONTROL_BREAK_OPTIONS
            ,    SUM_COLUMNS_ON_BREAK
            ,    AVG_COLUMNS_ON_BREAK
            ,    MAX_COLUMNS_ON_BREAK
            ,    MIN_COLUMNS_ON_BREAK
            ,    MEDIAN_COLUMNS_ON_BREAK
            ,    MODE_COLUMNS_ON_BREAK
            ,    COUNT_COLUMNS_ON_BREAK
            ,    COUNT_DISTNT_COL_ON_BREAK
            ,    FLASHBACK_MINS_AGO
            ,    FLASHBACK_ENABLED
            ,    CHART_TYPE
            ,    CHART_3D
            ,    CHART_LABEL_COLUMN
            ,    CHART_LABEL_TITLE
            ,    CHART_VALUE_COLUMN
            ,    CHART_AGGREGATE
            ,    CHART_VALUE_TITLE
            ,    CHART_SORTING
            ,    CALENDAR_DATE_COLUMN
            ,    CALENDAR_DISPLAY_COLUMN
            --    ,    CREATED_ON
            --    ,    CREATED_BY
            --    ,    UPDATED_ON
            --    ,    UPDATED_BY
            --    ,    SECURITY_GROUP_ID
          )
          Select   vReportID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    FLOW_ID
            ,    PAGE_ID
            ,    SESSION_ID
            ,    BASE_REPORT_ID
            ,    pUser
            ,    vReportName
            ,    DESCRIPTION
            ,    vReportSeq
            ,    REPORT_TYPE
            ,    REPORT_ALIAS
            ,    STATUS
            ,    VIEW_MODE
            ,    CATEGORY_ID
            ,    AUTOSAVE
            ,    IS_DEFAULT
            ,    DISPLAY_ROWS
            ,    PAGINATION_MIN_ROW
            ,    REPORT_COLUMNS
            ,    SORT_COLUMN_1
            ,    SORT_DIRECTION_1
            ,    SORT_COLUMN_2
            ,    SORT_DIRECTION_2
            ,    SORT_COLUMN_3
            ,    SORT_DIRECTION_3
            ,    SORT_COLUMN_4
            ,    SORT_DIRECTION_4
            ,    SORT_COLUMN_5
            ,    SORT_DIRECTION_5
            ,    SORT_COLUMN_6
            ,    SORT_DIRECTION_6
            ,    BREAK_ON
            ,    BREAK_ENABLED_ON
            ,    CONTROL_BREAK_OPTIONS
            ,    SUM_COLUMNS_ON_BREAK
            ,    AVG_COLUMNS_ON_BREAK
            ,    MAX_COLUMNS_ON_BREAK
            ,    MIN_COLUMNS_ON_BREAK
            ,    MEDIAN_COLUMNS_ON_BREAK
            ,    MODE_COLUMNS_ON_BREAK
            ,    COUNT_COLUMNS_ON_BREAK
            ,    COUNT_DISTNT_COL_ON_BREAK
            ,    FLASHBACK_MINS_AGO
            ,    FLASHBACK_ENABLED
            ,    CHART_TYPE
            ,    CHART_3D
            ,    CHART_LABEL_COLUMN
            ,    CHART_LABEL_TITLE
            ,    CHART_VALUE_COLUMN
            ,    CHART_AGGREGATE
            ,    CHART_VALUE_TITLE
            ,    CHART_SORTING
            ,    CALENDAR_DATE_COLUMN
            ,    CALENDAR_DISPLAY_COLUMN
          --    ,    CREATED_ON
          --    ,    CREATED_BY
          --    ,    UPDATED_ON
          --    ,    UPDATED_BY
          --    ,    SECURITY_GROUP_ID
          From    apex_040200.wwv_flow_worksheet_rpts
          where    id = pReportID;

        --  Create a record in
        --      Schema:     apex_040200
        --      Table:      wwv_flow_worksheet_computation
        --      PK:         wwv_flow_id.next_val
        insert    into
          apex_040200.wwv_flow_worksheet_computation (
            ID
            ,    FLOW_ID
            ,    PAGE_ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    REPORT_ID
            ,    DB_COLUMN_NAME
            ,    COLUMN_IDENTIFIER
            ,    COMPUTATION_EXPR
            ,    FORMAT_MASK
            ,    COLUMN_TYPE
            ,    COLUMN_LABEL
            ,    REPORT_LABEL
            --    ,    CREATED_ON
            --    ,    CREATED_BY
            --    ,    UPDATED_ON
            --    ,    UPDATED_BY
            --    ,    SECURITY_GROUP_ID
          )
          Select     wwv_flow_id.next_val
            ,    FLOW_ID
            ,    PAGE_ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    vReportID
            ,    DB_COLUMN_NAME
            ,    COLUMN_IDENTIFIER
            ,    COMPUTATION_EXPR
            ,    FORMAT_MASK
            ,    COLUMN_TYPE
            ,    COLUMN_LABEL
            ,    REPORT_LABEL
          --    ,    CREATED_ON
          --    ,    CREATED_BY
          --    ,    UPDATED_ON
          --    ,    UPDATED_BY
          --    ,    SECURITY_GROUP_ID
          From    apex_040200.wwv_flow_worksheet_computation
          where    REPORT_ID = pReportID;


        --  Create a record in
        --      Schema:     apex_040200
        --      Table:      wwv_flow_worksheet_conditions
        --      PK:         wwv_flow_id.next_val
        insert    into
          apex_040200.wwv_flow_worksheet_conditions (
            ID
            ,    FLOW_ID
            ,    PAGE_ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    REPORT_ID
            ,    NAME
            ,    CONDITION_TYPE
            ,    ALLOW_DELETE
            ,    COLUMN_NAME
            ,    OPERATOR
            ,    EXPR_TYPE
            ,    EXPR
            ,    EXPR2
            ,    TIME_ZONE
            ,    CONDITION_SQL
            ,    CONDITION_DISPLAY
            ,    ENABLED
            ,    HIGHLIGHT_SEQUENCE
            ,    ROW_BG_COLOR
            ,    ROW_FONT_COLOR
            ,    ROW_FORMAT
            ,    COLUMN_BG_COLOR
            ,    COLUMN_FONT_COLOR
            ,    COLUMN_FORMAT
            --    ,    CREATED_ON
            --    ,    CREATED_BY
            --    ,    UPDATED_ON
            --    ,    UPDATED_BY
            --    ,    SECURITY_GROUP_ID
          )
          Select     wwv_flow_id.next_val
            ,    FLOW_ID
            ,    PAGE_ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    vReportID
            ,    NAME
            ,    CONDITION_TYPE
            ,    ALLOW_DELETE
            ,    COLUMN_NAME
            ,    OPERATOR
            ,    EXPR_TYPE
            ,    EXPR
            ,    EXPR2
            ,    TIME_ZONE
            ,    CONDITION_SQL
            ,    CONDITION_DISPLAY
            ,    ENABLED
            ,    HIGHLIGHT_SEQUENCE
            ,    ROW_BG_COLOR
            ,    ROW_FONT_COLOR
            ,    ROW_FORMAT
            ,    COLUMN_BG_COLOR
            ,    COLUMN_FONT_COLOR
            ,    COLUMN_FORMAT
          --    ,    CREATED_ON
          --    ,    CREATED_BY
          --    ,    UPDATED_ON
          --    ,    UPDATED_BY
          --    ,    SECURITY_GROUP_ID
          From    apex_040200.wwv_flow_worksheet_conditions
          where    REPORT_ID = pReportID;

        --  Create a record in
        --      Schema:     apex_040200
        --      Table:      WWV_FLOW_WORKSHEET_GROUP_BY
        --      PK:         wwv_flow_id.next_val
        insert    into
          apex_040200.WWV_FLOW_WORKSHEET_GROUP_BY (
            ID
            ,    FLOW_ID
            ,    PAGE_ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    REPORT_ID
            ,    GROUP_BY_COLUMNS
            ,    FUNCTION_01
            ,    FUNCTION_COLUMN_01
            ,    FUNCTION_DB_COLUMN_NAME_01
            ,    FUNCTION_LABEL_01
            ,    FUNCTION_FORMAT_MASK_01
            ,    FUNCTION_SUM_01
            ,    FUNCTION_02
            ,    FUNCTION_COLUMN_02
            ,    FUNCTION_DB_COLUMN_NAME_02
            ,    FUNCTION_LABEL_02
            ,    FUNCTION_FORMAT_MASK_02
            ,    FUNCTION_SUM_02
            ,    FUNCTION_03
            ,    FUNCTION_COLUMN_03
            ,    FUNCTION_DB_COLUMN_NAME_03
            ,    FUNCTION_LABEL_03
            ,    FUNCTION_FORMAT_MASK_03
            ,    FUNCTION_SUM_03
            ,    FUNCTION_04
            ,    FUNCTION_COLUMN_04
            ,    FUNCTION_DB_COLUMN_NAME_04
            ,    FUNCTION_LABEL_04
            ,    FUNCTION_FORMAT_MASK_04
            ,    FUNCTION_SUM_04
            ,    FUNCTION_05
            ,    FUNCTION_COLUMN_05
            ,    FUNCTION_DB_COLUMN_NAME_05
            ,    FUNCTION_LABEL_05
            ,    FUNCTION_FORMAT_MASK_05
            ,    FUNCTION_SUM_05
            ,    FUNCTION_06
            ,    FUNCTION_COLUMN_06
            ,    FUNCTION_DB_COLUMN_NAME_06
            ,    FUNCTION_LABEL_06
            ,    FUNCTION_FORMAT_MASK_06
            ,    FUNCTION_SUM_06
            ,    FUNCTION_07
            ,    FUNCTION_COLUMN_07
            ,    FUNCTION_DB_COLUMN_NAME_07
            ,    FUNCTION_LABEL_07
            ,    FUNCTION_FORMAT_MASK_07
            ,    FUNCTION_SUM_07
            ,    FUNCTION_08
            ,    FUNCTION_COLUMN_08
            ,    FUNCTION_DB_COLUMN_NAME_08
            ,    FUNCTION_LABEL_08
            ,    FUNCTION_FORMAT_MASK_08
            ,    FUNCTION_SUM_08
            ,    FUNCTION_09
            ,    FUNCTION_COLUMN_09
            ,    FUNCTION_DB_COLUMN_NAME_09
            ,    FUNCTION_LABEL_09
            ,    FUNCTION_FORMAT_MASK_09
            ,    FUNCTION_SUM_09
            ,    FUNCTION_10
            ,    FUNCTION_COLUMN_10
            ,    FUNCTION_DB_COLUMN_NAME_10
            ,    FUNCTION_LABEL_10
            ,    FUNCTION_FORMAT_MASK_10
            ,    FUNCTION_SUM_10
            ,    FUNCTION_11
            ,    FUNCTION_COLUMN_11
            ,    FUNCTION_DB_COLUMN_NAME_11
            ,    FUNCTION_LABEL_11
            ,    FUNCTION_FORMAT_MASK_11
            ,    FUNCTION_SUM_11
            ,    FUNCTION_12
            ,    FUNCTION_COLUMN_12
            ,    FUNCTION_DB_COLUMN_NAME_12
            ,    FUNCTION_LABEL_12
            ,    FUNCTION_FORMAT_MASK_12
            ,    FUNCTION_SUM_12
            ,    SORT_COLUMN_01
            ,    SORT_DIRECTION_01
            ,    SORT_COLUMN_02
            ,    SORT_DIRECTION_02
            ,    SORT_COLUMN_03
            ,    SORT_DIRECTION_03
            ,    SORT_COLUMN_04
            ,    SORT_DIRECTION_04
            ,    SORT_COLUMN_05
            ,    SORT_DIRECTION_05
            ,    SORT_COLUMN_06
            ,    SORT_DIRECTION_06
            ,    SORT_COLUMN_07
            ,    SORT_DIRECTION_07
            ,    SORT_COLUMN_08
            ,    SORT_DIRECTION_08
            ,    SORT_COLUMN_09
            ,    SORT_DIRECTION_09
            ,    SORT_COLUMN_10
            ,    SORT_DIRECTION_10
            ,    SORT_COLUMN_11
            ,    SORT_DIRECTION_11
            ,    SORT_COLUMN_12
            ,    SORT_DIRECTION_12
            --    ,    CREATED_ON
            --    ,    CREATED_BY
            --    ,    UPDATED_ON
            --    ,    UPDATED_BY
            --    ,    SECURITY_GROUP_ID
          )
          Select     wwv_flow_id.next_val
            ,    FLOW_ID
            ,    PAGE_ID
            ,    WORKSHEET_ID
            ,    WEBSHEET_ID
            ,    vReportID
            ,    GROUP_BY_COLUMNS
            ,    FUNCTION_01
            ,    FUNCTION_COLUMN_01
            ,    FUNCTION_DB_COLUMN_NAME_01
            ,    FUNCTION_LABEL_01
            ,    FUNCTION_FORMAT_MASK_01
            ,    FUNCTION_SUM_01
            ,    FUNCTION_02
            ,    FUNCTION_COLUMN_02
            ,    FUNCTION_DB_COLUMN_NAME_02
            ,    FUNCTION_LABEL_02
            ,    FUNCTION_FORMAT_MASK_02
            ,    FUNCTION_SUM_02
            ,    FUNCTION_03
            ,    FUNCTION_COLUMN_03
            ,    FUNCTION_DB_COLUMN_NAME_03
            ,    FUNCTION_LABEL_03
            ,    FUNCTION_FORMAT_MASK_03
            ,    FUNCTION_SUM_03
            ,    FUNCTION_04
            ,    FUNCTION_COLUMN_04
            ,    FUNCTION_DB_COLUMN_NAME_04
            ,    FUNCTION_LABEL_04
            ,    FUNCTION_FORMAT_MASK_04
            ,    FUNCTION_SUM_04
            ,    FUNCTION_05
            ,    FUNCTION_COLUMN_05
            ,    FUNCTION_DB_COLUMN_NAME_05
            ,    FUNCTION_LABEL_05
            ,    FUNCTION_FORMAT_MASK_05
            ,    FUNCTION_SUM_05
            ,    FUNCTION_06
            ,    FUNCTION_COLUMN_06
            ,    FUNCTION_DB_COLUMN_NAME_06
            ,    FUNCTION_LABEL_06
            ,    FUNCTION_FORMAT_MASK_06
            ,    FUNCTION_SUM_06
            ,    FUNCTION_07
            ,    FUNCTION_COLUMN_07
            ,    FUNCTION_DB_COLUMN_NAME_07
            ,    FUNCTION_LABEL_07
            ,    FUNCTION_FORMAT_MASK_07
            ,    FUNCTION_SUM_07
            ,    FUNCTION_08
            ,    FUNCTION_COLUMN_08
            ,    FUNCTION_DB_COLUMN_NAME_08
            ,    FUNCTION_LABEL_08
            ,    FUNCTION_FORMAT_MASK_08
            ,    FUNCTION_SUM_08
            ,    FUNCTION_09
            ,    FUNCTION_COLUMN_09
            ,    FUNCTION_DB_COLUMN_NAME_09
            ,    FUNCTION_LABEL_09
            ,    FUNCTION_FORMAT_MASK_09
            ,    FUNCTION_SUM_09
            ,    FUNCTION_10
            ,    FUNCTION_COLUMN_10
            ,    FUNCTION_DB_COLUMN_NAME_10
            ,    FUNCTION_LABEL_10
            ,    FUNCTION_FORMAT_MASK_10
            ,    FUNCTION_SUM_10
            ,    FUNCTION_11
            ,    FUNCTION_COLUMN_11
            ,    FUNCTION_DB_COLUMN_NAME_11
            ,    FUNCTION_LABEL_11
            ,    FUNCTION_FORMAT_MASK_11
            ,    FUNCTION_SUM_11
            ,    FUNCTION_12
            ,    FUNCTION_COLUMN_12
            ,    FUNCTION_DB_COLUMN_NAME_12
            ,    FUNCTION_LABEL_12
            ,    FUNCTION_FORMAT_MASK_12
            ,    FUNCTION_SUM_12
            ,    SORT_COLUMN_01
            ,    SORT_DIRECTION_01
            ,    SORT_COLUMN_02
            ,    SORT_DIRECTION_02
            ,    SORT_COLUMN_03
            ,    SORT_DIRECTION_03
            ,    SORT_COLUMN_04
            ,    SORT_DIRECTION_04
            ,    SORT_COLUMN_05
            ,    SORT_DIRECTION_05
            ,    SORT_COLUMN_06
            ,    SORT_DIRECTION_06
            ,    SORT_COLUMN_07
            ,    SORT_DIRECTION_07
            ,    SORT_COLUMN_08
            ,    SORT_DIRECTION_08
            ,    SORT_COLUMN_09
            ,    SORT_DIRECTION_09
            ,    SORT_COLUMN_10
            ,    SORT_DIRECTION_10
            ,    SORT_COLUMN_11
            ,    SORT_DIRECTION_11
            ,    SORT_COLUMN_12
            ,    SORT_DIRECTION_12
          --    ,    CREATED_ON
          --    ,    CREATED_BY
          --    ,    UPDATED_ON
          --    ,    UPDATED_BY
          --    ,    SECURITY_GROUP_ID
          From    apex_040200.WWV_FLOW_WORKSHEET_GROUP_BY
          where    REPORT_ID = pReportID;
        Exception
        when others then
        RtnMsg := sqlerrm;
      END;
    END IF;
    Return  RtnMsg;
  END;​