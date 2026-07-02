package com.gu.model.dto;

public class FavoriteToggleResponse {
    private String productId;
    private boolean isFavorited;

    public FavoriteToggleResponse(String productId, boolean isFavorited) {
        this.productId = productId;
        this.isFavorited = isFavorited;
    }

    public String getProductId() { return productId; }
    public boolean isFavorited() { return isFavorited; }
}