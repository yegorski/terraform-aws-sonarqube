package test

import (
	"crypto/tls"
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	random "github.com/gruntwork-io/terratest/modules/random"
	terraform "github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

// Map of test stages, not required but eliminates typos when specifying stages in each step
const (
	setup    string = "setup"
	validate string = "validate"
	teardown string = "teardown"
)

func Test_PackerTerraformSonarqube(t *testing.T) {
	t.Parallel()

	fixtureDir := "./fixture"

	// Destroy resources after the test is complete, either passed or failed
	defer test_structure.RunTestStage(t, teardown, func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureDir)

		terraform.Destroy(t, terraformOptions)
	})

	// Apply Terraform
	test_structure.RunTestStage(t, setup, func() {
		terraformOptions := configureTerraformOptions(t, fixtureDir)

		test_structure.SaveTerraformOptions(t, fixtureDir, terraformOptions)

		terraform.InitAndApply(t, terraformOptions)
	})

	// Run the test
	test_structure.RunTestStage(t, validate, func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureDir)

		validateServerIsRunning(t, terraformOptions)
	})
}

// Pass in Terraform varibles to the test
func configureTerraformOptions(t *testing.T, fixtureDir string) *terraform.Options {
	return &terraform.Options{
		TerraformDir: fixtureDir,
		Vars: map[string]interface{}{
			"app_name":       fmt.Sprintf("sonarqube-%s", strings.ToLower(random.UniqueId())),
			"aws_account_id": "945621581510",
		},
	}
}

func validateServerIsRunning(t *testing.T, terraformOptions *terraform.Options) {
	retries := 30
	sleep := 6 * time.Second
	fqdn := terraform.Output(t, terraformOptions, "lb_dns_name")
	url := fmt.Sprintf("http://%s", fqdn)

	// Query the load balancer (Terraform output `lb_dns_name`)
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		&tls.Config{
			InsecureSkipVerify: true,
		},
		retries,
		sleep,
		// Look for the presence of "window.instance = 'SonarQube';" in the website HTML
		func(statusCode int, body string) bool {
			return statusCode == 200 && strings.Contains(body, "window.instance = 'SonarQube';")
		},
	)
}
