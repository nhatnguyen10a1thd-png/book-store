USE BookStore;
GO

-- 1. Đặt một đơn COD thử trên website, ghi lại mã đơn và ID tài khoản.
-- 2. Điền hai ID bên dưới. Chạy với @NewStatus = NULL để xem trạng thái gốc.
-- 3. Ghi lại trạng thái gốc trước khi thử; thay @NewStatus và chạy lại từng lần.
-- 4. Tải lại /orders hoặc chọn bộ lọc tương ứng sau mỗi lần chạy.
-- 5. Kết thúc: chạy lại với @NewStatus bằng trạng thái gốc (thường là PENDING).
-- Chỉ đổi order_status; không hoàn tồn kho hoặc thay đổi thanh toán.
-- PENDING    = Đơn hàng mới       CONFIRMED = Đã xác nhận
-- PREPARING  = Chuẩn bị hàng      SHIPPING  = Vận chuyển
-- DELIVERING = Giao hàng          DELIVERED = Đã giao
-- CANCELLED  = Đơn hàng hủy       RETURNED  = Đơn hàng hoàn

SET XACT_ABORT ON;
DECLARE @OrderId INT = NULL;       -- Mã đơn thử
DECLARE @UserId INT = NULL;        -- ID tài khoản sở hữu đơn thử
DECLARE @NewStatus VARCHAR(30) = NULL; -- NULL: chỉ xem, không cập nhật

IF @OrderId IS NULL OR @UserId IS NULL
    THROW 50001, N'Hãy điền mã đơn thử và ID tài khoản trước khi chạy.', 1;

IF @NewStatus IS NOT NULL AND @NewStatus COLLATE Latin1_General_100_BIN2 NOT IN
    ('PENDING', 'CONFIRMED', 'PREPARING', 'SHIPPING', 'DELIVERING', 'DELIVERED', 'CANCELLED', 'RETURNED')
    THROW 50002, N'Mã trạng thái không hợp lệ.', 1;

BEGIN TRY
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.orders WITH (UPDLOCK, HOLDLOCK)
                   WHERE order_id = @OrderId AND user_id = @UserId)
        THROW 50003, N'Không tìm thấy đơn thuộc tài khoản đã chọn.', 1;

    SELECT order_id, user_id, order_status AS original_status
    FROM dbo.orders WHERE order_id = @OrderId AND user_id = @UserId;

    IF @NewStatus IS NOT NULL
    BEGIN
        UPDATE dbo.orders SET order_status = @NewStatus
        WHERE order_id = @OrderId AND user_id = @UserId;
        IF @@ROWCOUNT <> 1
            THROW 50004, N'Cập nhật phải tác động đúng một đơn.', 1;
    END;

    SELECT order_id, user_id, order_status, created_at
    FROM dbo.orders WHERE order_id = @OrderId AND user_id = @UserId;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
