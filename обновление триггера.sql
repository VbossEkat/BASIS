set ANSI_NULLS OFF
set QUOTED_IDENTIFIER OFF
GO
ALTER trigger [dbo].[tU_Storage] on [dbo].[Storage] for UPDATE as
/* ERwin Builtin Sun Jul 09 16:26:52 2006 */
/* UPDATE trigger on Storage */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStorageID int,
           @errno   int,
           @errmsg  varchar(255)

  select @numrows = @@rowcount
  /* ERwin Builtin Sun Jul 09 16:26:52 2006 */
  /* OrgUnit R/248 Storage ON CHILD UPDATE RESTRICT */
  if
    /* update(StorageID) */
    update(StorageID)
  begin
    select @nullcnt = 0
    select @validcnt = count(*)
      from inserted,OrgUnit
        where
          /* inserted.StorageID = OrgUnit.OUID */
          inserted.StorageID = OrgUnit.OUID
    /*  */
    
    if @validcnt + @nullcnt != @numrows
    begin
      select @errno  = 30007,
             @errmsg = 'Cannot UPDATE Storage because OrgUnit does not exist.'
      goto error
    end
  end

  /* ERwin Builtin Sun Jul 09 16:26:52 2006 */
  /* Device R/177 Storage ON CHILD UPDATE RESTRICT */
  if
    /* update(StorageDeviceID) */
    update(StorageDeviceID)
  begin
    select @nullcnt = 0
    select @validcnt = count(*)
      from inserted,Device
        where
          /* inserted.StorageDeviceID = Device.DeviceID */
          inserted.StorageDeviceID = Device.DeviceID
    /*  */
    
    if @validcnt + @nullcnt != @numrows
    begin
      select @errno  = 30007,
             @errmsg = 'Обновление приостановлено: Укажите сервер обмена.'
      goto error
    end
  end

  /* ERwin Builtin Sun Jul 09 16:26:52 2006 */
  /* PrcType R/176 Storage ON CHILD UPDATE RESTRICT */
  if
    /* update(StoragePrcTypeId) */
    update(StoragePrcTypeId)
  begin
    select @nullcnt = 0
    select @validcnt = count(*)
      from inserted,PrcType
        where
          /* inserted.StoragePrcTypeId = PrcType.PrcTypeId */
          inserted.StoragePrcTypeId = PrcType.PrcTypeId
    /*  */
    
    if @validcnt + @nullcnt != @numrows
    begin
      select @errno  = 30007,
             @errmsg = 'Обновление приостановлено: укажите Прайс.'
      goto error
    end
  end


  /* ERwin Builtin Sun Jul 09 16:26:52 2006 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end
