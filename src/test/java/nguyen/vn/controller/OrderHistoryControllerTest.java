package nguyen.vn.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import nguyen.vn.model.OrderStatus_24110288;
import nguyen.vn.model.Order_24110288;
import nguyen.vn.model.User_24110288;
import nguyen.vn.service.IOrderHistoryService_24110288;
import nguyen.vn.service.OrderHistoryException_24110288;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

class OrderHistoryControllerTest {
    private final IOrderHistoryService_24110288 service = mock(IOrderHistoryService_24110288.class);
    private final HttpServletRequest request = mock(HttpServletRequest.class);
    private final HttpServletResponse response = mock(HttpServletResponse.class);
    private final HttpSession session = mock(HttpSession.class);
    private final RequestDispatcher dispatcher = mock(RequestDispatcher.class);
    private final OrderHistoryController_24110288 controller = new OrderHistoryController_24110288(service);

    @BeforeEach
    void setup() {
        when(request.getContextPath()).thenReturn("/KTQTDemo");
        when(request.getRequestDispatcher("/WEB-INF/views/orders.jsp")).thenReturn(dispatcher);
    }

    private void login(int id) {
        User_24110288 user = new User_24110288();
        user.setId(id);
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(user);
    }

    @Test
    void anonymousUserMustLogInAndKeepsValidFilter() throws Exception {
        when(request.getParameter("status")).thenReturn("SHIPPING");
        controller.doGet(request, response);
        verify(response).sendRedirect("/KTQTDemo/login?redirect=%2Forders%3Fstatus%3DSHIPPING");
        verifyNoInteractions(service, dispatcher);
    }

    @Test
    void expiredSessionRedirectsWithoutQueryingOrders() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        controller.doGet(request, response);
        verify(response).sendRedirect("/KTQTDemo/login?redirect=%2Forders");
        verifyNoInteractions(service);
    }

    @ParameterizedTest
    @EnumSource(OrderStatus_24110288.class)
    void filtersEveryStatusUsingSessionOwner(OrderStatus_24110288 status) throws Exception {
        login(17);
        when(request.getParameter("userId")).thenReturn("99");
        when(request.getParameter("status")).thenReturn(status.getCode());
        Order_24110288 order = new Order_24110288();
        List<Order_24110288> orders = List.of(order);
        when(service.getOrders(17, status)).thenReturn(orders);
        controller.doGet(request, response);
        verify(service).getOrders(17, status);
        verify(request).setAttribute("orders", orders);
        verify(request).setAttribute("selectedStatus", status.getCode());
        verify(response).setHeader("Cache-Control", "no-store");
        verify(dispatcher).forward(request, response);
    }

    @ParameterizedTest
    @NullAndEmptySource
    @ValueSource(strings = "   ")
    void missingOrBlankStatusShowsAll(String status) throws Exception {
        login(17);
        when(request.getParameter("status")).thenReturn(status);
        when(service.getOrders(17, null)).thenReturn(List.of());
        controller.doGet(request, response);
        verify(service).getOrders(17, null);
        verify(request).setAttribute("selectedStatus", "");
        verify(request).setAttribute("orders", List.of());
        verify(request, never()).setAttribute(eq("historyError"), any());
    }

    @ParameterizedTest
    @ValueSource(strings = {"INVALID", "pending", "PENDING' OR 1=1--", " PENDING "})
    void rejectsInvalidFiltersBeforeDatabaseAccess(String status) throws Exception {
        login(17);
        when(request.getParameter("status")).thenReturn(status);
        controller.doGet(request, response);
        verify(response).sendError(eq(400), anyString());
        verifyNoInteractions(service, dispatcher);
    }

    @Test
    void differentSessionUsesDifferentOwner() throws Exception {
        login(22);
        controller.doGet(request, response);
        verify(service).getOrders(22, null);
        verify(service, never()).getOrders(eq(17), any());
    }

    @Test
    void databaseFailureIsNotShownAsEmptyHistory() throws Exception {
        login(17);
        when(service.getOrders(17, null)).thenThrow(
                new OrderHistoryException_24110288("Private database details", new Exception("test")));
        controller.doGet(request, response);
        verify(response).setStatus(500);
        verify(request).setAttribute("historyError", "Không thể tải lịch sử đặt hàng. Vui lòng thử lại sau.");
        verify(request, never()).setAttribute(eq("orders"), any());
        verify(dispatcher).forward(request, response);
    }

    @Test
    void reloadRetrievesCurrentStateAgain() throws Exception {
        login(17);
        Order_24110288 before = new Order_24110288();
        before.setOrderStatus("PENDING");
        Order_24110288 after = new Order_24110288();
        after.setOrderStatus("DELIVERED");
        when(service.getOrders(17, null)).thenReturn(List.of(before), List.of(after));
        controller.doGet(request, response);
        controller.doGet(request, response);
        verify(service, times(2)).getOrders(17, null);
        verify(request).setAttribute("orders", List.of(before));
        verify(request).setAttribute("orders", List.of(after));
    }

    @Test
    void unknownDatabaseStatusHasSafeFallback() {
        Order_24110288 order = new Order_24110288();
        order.setOrderStatus("UNEXPECTED<script>");
        assertEquals("Không xác định", order.getStatusLabel());
        assertEquals("UNKNOWN", order.getStatusCode());
    }
}
