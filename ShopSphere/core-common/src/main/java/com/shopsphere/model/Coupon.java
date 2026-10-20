package com.shopsphere.model;

import java.io.Serializable;
import java.sql.Date;

public class Coupon implements Serializable {
    private static final long serialVersionUID = 1L;

    private int couponId;
    private String code;
    private String discountType; // "PERCENTAGE", "FIXED"
    private double discountValue;
    private double minimumOrder;
    private Double maximumDiscount;
    private Date expiryDate;
    private String status; // "ACTIVE", "EXPIRED", "DISABLED"

    public Coupon() {}

    public Coupon(int couponId, String code, String discountType, double discountValue,
                  double minimumOrder, Double maximumDiscount, Date expiryDate, String status) {
        this.couponId = couponId;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minimumOrder = minimumOrder;
        this.maximumDiscount = maximumDiscount;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getCouponId() { return couponId; }
    public void setCouponId(int couponId) { this.couponId = couponId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public double getMinimumOrder() { return minimumOrder; }
    public void setMinimumOrder(double minimumOrder) { this.minimumOrder = minimumOrder; }

    public Double getMaximumDiscount() { return maximumDiscount; }
    public void setMaximumDiscount(Double maximumDiscount) { this.maximumDiscount = maximumDiscount; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    /**
     * Calculates the discount amount for a given order total.
     */
    public double calculateDiscount(double orderTotal) {
        if (!"ACTIVE".equalsIgnoreCase(status) || orderTotal < minimumOrder) {
            return 0.0;
        }
        double discount;
        if ("PERCENTAGE".equalsIgnoreCase(discountType)) {
            discount = orderTotal * (discountValue / 100.0);
            if (maximumDiscount != null && maximumDiscount > 0 && discount > maximumDiscount) {
                discount = maximumDiscount;
            }
        } else {
            discount = discountValue;
        }
        return Math.min(orderTotal, Math.round(discount * 100.0) / 100.0);
    }
}
