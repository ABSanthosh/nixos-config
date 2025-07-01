package main

import (
	"fmt"
	"os"
	"testing"

	"github.com/getsops/sops/v3/decrypt"
	"github.com/xlzd/gotp"
	"gopkg.in/yaml.v2"
)

func findTOTPSecret(secrets Secrets, name string) (string, error) {
	secret, ok := secrets.TOTP[name]
	if !ok {
		return "", fmt.Errorf("no TOTP secret found for %q", name)
	}
	return secret, nil
}

func TestFindTOTPSecretFromDecryptedFile(t *testing.T) {
	const secretsPath = "/etc/nixos/secrets.yaml"

	// Check if the file exists
	if _, err := os.Stat(secretsPath); os.IsNotExist(err) {
		t.Skipf("Skipping test: file %s not found", secretsPath)
	}

	// Decrypt the file
	plain, err := decrypt.File(secretsPath, "yaml")
	if err != nil {
		t.Fatalf("Failed to decrypt file: %v", err)
	}

	// Parse the YAML
	var secrets Secrets
	if err := yaml.Unmarshal([]byte(plain), &secrets); err != nil {
		t.Fatalf("Failed to parse YAML: %v", err)
	}

	// Define the test cases — change these names to match your actual accounts
	tests := []struct {
		accountName string
		expectErr   bool
	}{
		{"PSU", false},
		{"Binance", false},
		{"UnknownService", true},
	}

	for _, tt := range tests {
		secret, err := findTOTPSecret(secrets, tt.accountName)
		if (err != nil) != tt.expectErr {
			t.Errorf("findTOTPSecret(%q) error = %v, wantErr = %v", tt.accountName, err, tt.expectErr)
		}
		if !tt.expectErr && secret == "" {
			t.Errorf("Expected non-empty secret for account %q", tt.accountName)
		}
	}
}

func TestGenerateTOTP(t *testing.T) {
	// This secret always returns the same result for time.Now() = 0
	totp := gotp.NewDefaultTOTP("JBSWY3DPEHPK3PXP")
	code := totp.At(0) // Fixed time so the test is stable
	expected := "282760"

	if code != expected {
		t.Errorf("Expected TOTP %s, got %s", expected, code)
	}
}
