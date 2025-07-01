// Alternative for https://github.com/evansmurithi/cloak
// Based on: https://github.com/getsops/sotp
package main

import (
	"fmt"
	"log"
	"os"
	"regexp"

	"github.com/xlzd/gotp"
	"gopkg.in/yaml.v2"

	"github.com/getsops/sops/v3/decrypt"
)

type Secrets struct {
	TOTP map[string]string `yaml:"totp"`
}

var accountNameRe = `^[a-zA-Z0-9-_.]{3,64}$`

func main() {
	if len(os.Args) != 2 {
		log.Fatal("usage: sotp <account_name>")
	}
	accountName := os.Args[1]
	if !regexp.MustCompile(accountNameRe).MatchString(accountName) {
		log.Fatalf("Invalid account name: %q", accountName)
	}

	otp, err := getTOTP("/etc/nixos/secrets.yaml", accountName)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(otp)
}

func getTOTP(path, name string) (string, error) {
	plainText, err := decrypt.File(path, "yaml")
	if err != nil {
		return "", fmt.Errorf("failed to decrypt file: %w", err)
	}

	var secrets Secrets
	if err := yaml.Unmarshal([]byte(plainText), &secrets); err != nil {
		return "", fmt.Errorf("failed to parse yaml: %w", err)
	}

	secret, ok := secrets.TOTP[name]
	if !ok {
		return "", fmt.Errorf("no TOTP secret for %q", name)
	}

	totp := gotp.NewDefaultTOTP(secret)
	return totp.Now(), nil
}
